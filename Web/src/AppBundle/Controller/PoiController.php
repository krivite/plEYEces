<?php

namespace AppBundle\Controller;

use AppBundle\Entity;
use AppBundle\Entity\Poi;
use AppBundle\Entity\PoiType;
use FOS\RestBundle\Controller\FOSRestController;
use FOS\RestBundle\Controller\Annotations as Rest;
use function Sodium\add;
use Symfony\Component\HttpFoundation\Response;
use Nelmio\ApiDocBundle\Annotation\Model;
use Swagger\Annotations as SWG;
use FOS\RestBundle\View\View;
use Symfony\Component\HttpFoundation\Request;
use Doctrine\ORM\Mapping as ORM;


class PoiController extends FOSRestController
{
    /**
     * @Rest\Get("/api/pois")
     * @SWG\Response(
     *     response=200,
     *     description="Returns pois from database",
     * )
     * @SWG\Tag(name="pois")
     */
    public function getAll()
    {
        $result = $this->getDoctrine()->getRepository('AppBundle:Poi')->findAll();
        if ($result === null || count($result) === 0) {
            return new View("No POIs found!", Response::HTTP_NOT_FOUND);
        }
        return $result;
    }

    /**
     * @Rest\Get("/api/poi/{id}")
     * @SWG\Response(
     *     response=200,
     *     description="Returns a single poi from database",
     * )
     * @SWG\Parameter(
     *     name="id",
     *     in="path",
     *     type="integer",
     *     description="ID of poi whose details you want to see"
     * )
     * @SWG\Tag(name="poi")
     */
    public function getAction($id)
    {
        $result = $this->getDoctrine()->getRepository('AppBundle:Poi')->find($id);
        if ($result === null) {
            return new View("POI not found!", Response::HTTP_NOT_FOUND);
        }
        return $result;
    }

    /**
     * @Rest\Get("/api/pois/location")
     * @SWG\Response(
     *     response=200,
     *     description="Returns pois from database whose distance from the given location is less than radius"
     * )
     * @SWG\Parameter(
     *     name="latitude",
     *     in="query",
     *     type="number",
     *     description="Latitude of your current location"
     * )
     * @SWG\Parameter(
     *     name="longitude",
     *     in="query",
     *     type="number",
     *     description="Longitude of your current location"
     * )
     * @SWG\Parameter(
     *     name="radius",
     *     in="query",
     *     type="number",
     *     description="Radius is distance from your location to the end of your search area. Distance is measured in kilometres"
     * )
     * @SWG\Tag(name="poi")
     */
    public function getInRadius(Request $request)
    {
        //get parameters
        $longitude = $request->query->get('longitude');
        $latitude = $request->query->get('latitude');
        $radius = $request->query->get('radius');

        //calculate radians
        $radianLongitude = ($longitude * pi()) / 180;
        $radianLatitude = ($latitude * pi()) / 180;

        //TODO: poslati zahtjev na google places api

        $placesApiNearBySearchUrl = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json?' .
            'key=AIzaSyBYuz2HZWdjthly1NlGKqGA-TPsuHms3ZA' .
            '&location=' . $latitude . ',' . $longitude .
            '&radius=' . $radius*1000;

        $nearByPois = $this->getApiResultParametar($placesApiNearBySearchUrl, 'results');
        $poiJSONResponse = $this->fillArrayOfNearByPois($nearByPois);

        $result = new Response(
            json_encode($poiJSONResponse),
            Response::HTTP_OK,
            array('content-type' => 'application/json')
        );

        return $result;


        //TODO: update baze prema vraćenim podatcima


        /*$result = $this->getDoctrine()->getManager()->getRepository(\AppBundle\Entity\Poi::class)->findInRadius($radianLatitude, $radianLongitude, $radius);
        if ($result === null) {
            return [];
        }
        return $result;*/
    }

    //returns result field of response object from given url
    private function getApiResultParametar($url, $field)
    {
        $browser = $this->container->get('buzz');
        $response = json_decode($browser->get($url)->getContent(), true);
        return $response[$field];
    }

    //takes near by pois and fill them in array of pois with data from places api
    private function fillArrayOfNearByPois($nearByPois)
    {
        $poiTypes = $this->getDoctrine()->getManager()->getRepository(PoiType::class)->findAll();
        $poiJSONResponse = [];
        foreach($nearByPois as $nearByPoi)
        {
            //check does current result type matches the one in database
            $poiType = $this->matchingPoiType($poiTypes, $nearByPoi);
            if($poiType == null)
                continue;

            $poi = new Poi();
            $poi->setId($nearByPoi['id']);
            $poi->setName($nearByPoi['name']);

            //getting details
            $placesApiDetailsUrl = 'https://maps.googleapis.com/maps/api/place/details/json?' .
                'key=AIzaSyBYuz2HZWdjthly1NlGKqGA-TPsuHms3ZA' .
                '&placeid=' . $nearByPoi['place_id'];
            $details = $this->getApiResultParametar($placesApiDetailsUrl, 'result');

            $poi->setAddress($details['formatted_address']);
            $poi->setDetails($details['url']);

            $poi->setImage('https://maps.googleapis.com/maps/api/place/photo?' .
                'key=AIzaSyBYuz2HZWdjthly1NlGKqGA-TPsuHms3ZA' .
                '&maxwidth=1920' .
                '&photoreference=' . $details['photos'][0]['photo_reference']);

            $poi->setLatitude($nearByPoi['geometry']['location']['lat']);
            $poi->setLongitude($nearByPoi['geometry']['location']['lng']);

            $poi->setWorkingHours($this->getWorkingHours($details));
            $poi->setType($poiType);

            array_push($poiJSONResponse, $poi);
        }
        return $poiJSONResponse;
    }

    //checks if poi type exists in database
    private function matchingPoiType($poiTypes, $nearByPoi)
    {
        $poiType = null;
        foreach($poiTypes as $type) {
            if (in_array($type->getName(), $nearByPoi['types'])) {
                $poiType = $type;
                break;
            }
        }
        return $poiType;
    }

    //creates string of working hours
    private function getWorkingHours($details)
    {
        $workingHours = "";
        foreach ($details['opening_hours']['weekday_text'] as $day)
        {
            $workingHours .= $day . " ";
        }

        return $workingHours;
    }
}