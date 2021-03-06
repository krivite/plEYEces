<?php

namespace AppBundle\Service;


use AppBundle\Entity\Offer;
use AppBundle\Entity\Poi;
use AppBundle\Entity\PoiType;
use Doctrine\Common\Collections\ArrayCollection;
use Doctrine\ORM\EntityManager;
use Symfony\Component\DependencyInjection\ContainerInterface as Container;

class PoiFilterService
{

    private $em;
    private $container;

    public function __construct(EntityManager $em, Container $container)
    {
        $this->em = $em;
        $this->container = $container;
    }

    /**
     * @param $placesResponse - array with response from places api
     * @return array
     */
    public function createPoiObjects($placesResponse)
    {
        //array that is going to be filled with Poi objects
        $pois = array();

        //fetching all types from database
        $poiTypes = $this->em->getRepository(PoiType::class)->findAll();

        foreach($placesResponse as $nearByPoi)
        {
            //check does current result type matches the one in database
            $poiType = $this->matchingPoiType($poiTypes, $nearByPoi);
            if($poiType == null)
                continue;
            $poi = $this->em->getRepository('AppBundle:Poi')->find($nearByPoi['id']);
            if(is_null($poi)) {
                $poi = new Poi();
                $poi->setId($nearByPoi['id']);
                $poi->setName($nearByPoi['name']);

                $details = $this->container->get('app.service.google_places_fetcher_service')->getDetails($nearByPoi['place_id']);

                $poi->setAddress($details['formatted_address']);
                $poi->setDetails("");

                if (array_key_exists('photos', $details))
                    $poi->setImage('https://maps.googleapis.com/maps/api/place/photo?' .
                        'key=AIzaSyBYuz2HZWdjthly1NlGKqGA-TPsuHms3ZA' .
                        '&maxwidth=1920' .
                        '&photoreference=' . $details['photos'][0]['photo_reference']);

                $poi->setLatitude($nearByPoi['geometry']['location']['lat']);
                $poi->setLongitude($nearByPoi['geometry']['location']['lng']);

                $poi->setWorkingHours($this->getWorkingHours($details));
                $poi->setType($poiType);

                $poiFromDatabase = $this->em->getRepository(Poi::class)->findOneBy(array('id' => $poi->getId()));
                if (!is_null($poiFromDatabase)) {
                    $offers = $this->em->getRepository(Offer::class)->findBy(array('poi' => $poi));
                    foreach ($offers as $offer)
                        $poi->addOffer($offer);
                }
            }
            array_push($pois, $poi);
        }

        return $pois;
    }

    private function matchingPoiType($poiTypes, $nearByPoi)
    {
        $poiType = null;
        foreach($poiTypes as $type) {
            if (in_array($type->getPlacesId(), $nearByPoi['types'])) {
                $poiType = $type;
                return $poiType;
            }
        }
        return $poiType;
    }

    //creates string of working hours
    private function getWorkingHours($details)
    {
        $working_hours = "";
        if(array_key_exists('opening_hours', $details)) {
            foreach ($details['opening_hours']['weekday_text'] as $day) {
                $working_hours .= $day . " ";
            }
        }

        return $working_hours;
    }
}