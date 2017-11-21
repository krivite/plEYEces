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
        $poiJSONResponse = [];
        $longitude = $request->query->get('longitude');
        $latitude = $request->query->get('latitude');
        $radius = $request->query->get('radius');

        $radianLongitude = ($longitude * pi()) / 180;
        $radianLatitude = ($latitude * pi()) / 180;

        //TODO: poslati zahtjev na google places api

        $browser = $this->container->get('buzz');
        $url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json?' .
            'key=AIzaSyBYuz2HZWdjthly1NlGKqGA-TPsuHms3ZA' .
            '&location=' . $latitude . ',' . $longitude .
            '&radius=' . $radius*1000;

        $response = $browser->get($url)->getContent();

        $response = json_decode($response, true);

        //var_dump($response['results'][0]);

        $poiTypes = $this->getDoctrine()->getManager()->getRepository(PoiType::class)->findAll();
        //$query = $this->getDoctrine()->getManager()->createQuery('SELECT p.id FROM  \AppBundle\Entity\Poi p');
        //$poiIds = $query->getResult();
        //var_dump($poiIds);

        foreach($response['results'] as $result)
        {
            //check does current result type matches the one in database
            $matchType = false;
            $poiType = null;
            foreach($poiTypes as $type)
            {
                if(in_array($type->getName(), $result['types']))
                {
                    $matchType = true;
                    $poiType = $type;
                    break;
                }
            }
            if(!$matchType)
            {
                continue;
            }

            $poi = new Poi();
            $poi->setId($result['id']);
            $poi->setName($result['name']);

            //getting details
            $url = 'https://maps.googleapis.com/maps/api/place/details/json?' .
                'key=AIzaSyBYuz2HZWdjthly1NlGKqGA-TPsuHms3ZA' .
                '&placeid=' . $result['place_id'];
            $details = $browser->get($url)->getContent();
            $details = json_decode($details, true);

            $poi->setAddress($details['result']['formatted_address']);
            $poi->setDetails($details['result']['url']);

            $poi->setImage('https://maps.googleapis.com/maps/api/place/photo?' .
                'key=AIzaSyBYuz2HZWdjthly1NlGKqGA-TPsuHms3ZA' .
                '&maxwidth=1920' .
                '&photoreference=' . $details['result']['photos'][0]['photo_reference']);

            $poi->setLatitude($result['geometry']['location']['lat']);
            $poi->setLongitude($result['geometry']['location']['lng']);

            $workingHours = "";
            foreach ($details['result']['opening_hours']['weekday_text'] as $day)
            {
                $workingHours .= $day . " ";
            }

            $poi->setWorkingHours($workingHours);
            $poi->setType($poiType);

            array_push($poiJSONResponse, $poi);
        }

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
}