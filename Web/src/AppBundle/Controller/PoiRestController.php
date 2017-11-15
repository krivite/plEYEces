<?php

namespace AppBundle\Controller;

use AppBundle\Entity;
use FOS\RestBundle\Controller\FOSRestController;
use FOS\RestBundle\Controller\Annotations as Rest;
use Symfony\Component\HttpFoundation\Response;
use Nelmio\ApiDocBundle\Annotation\Model;
use Swagger\Annotations as SWG;
use FOS\RestBundle\View\View;
use Symfony\Component\HttpFoundation\Request;
use Doctrine\ORM\Mapping as ORM;

class PoiRestController extends FOSRestController
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
        $longitude = $request->query->get('longitude');
        $latitude = $request->query->get('latitude');
        $radius = $request->query->get('radius');

        $radianLongitude = ($longitude * pi()) / 180;
        $radianLatitude = ($latitude * pi()) / 180;

        $result = $this->getDoctrine()->getManager()->getRepository(\AppBundle\Entity\Poi::class)->findInRadius($radianLatitude, $radianLongitude, $radius);
        if ($result === null) {
            return [];
        }
        return $result;
    }
}