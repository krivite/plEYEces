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
     *     description="Radius is distance from your location to the end of your search area. Distance is measured in meters"
     * )
     * @SWG\Tag(name="poi")
     */
    public function getInRadius(Request $request)
    {
        //get parameters
        $longitude = $request->query->get('longitude');
        $latitude = $request->query->get('latitude');
        $radius = $request->query->get('radius');

        $result = new Response(
            json_encode($this->get('app.service.google_places_fetcher_service')->getByGeolocation($latitude, $longitude, $radius)),
            Response::HTTP_OK,
            array('content-type' => 'application/json')
        );

        return $result;
    }

    /**
     * @Rest\Get("/api/categories")
     * @SWG\Response(
     *     response=200,
     *     description="Returns categories from database",
     * )
     * @SWG\Tag(name="categories")
     */
    public function getAllCategories()
    {
        $em=$this->getDoctrine()->getManager();
        $query=$em->createQueryBuilder()
            ->select('p.id,p.name,p.color,p.icon,(COUNT(a.id )) as poiCount')
            ->from('AppBundle:PoiType','p')
            ->innerJoin('p.pois','a')
            ->groupBy('p.id');
        $result=$query->getQuery()->getResult();
        foreach($result as &$row){
            $row['poiCount']=intval($row['poiCount']);
        }
        if ($result === null || count($result) === 0) {
            return new View("No Categories found!", Response::HTTP_NOT_FOUND);
        }
        return $result;
    }

    /**
     * @Rest\Get("/api/poisWithOffers")
     * @SWG\Response(
     *     response=200,
     *     description="Returns only pois with offer from database",
     * )
     * @SWG\Tag(name="poisWithOffers")
     */
    public function getAllOffers()
    {
        //$result = $this->getDoctrine()->getRepository('AppBundle:Offer')->findAll();
        $em=$this->getDoctrine()->getManager();
        $query=$em->createQueryBuilder()
            ->select('p')
            ->from('AppBundle:Poi','p')
            ->innerJoin('p.offers','a')
            ->groupBy('p.id');

        $result=$query->getQuery()->getResult();
        if ($result === null || count($result) === 0) {
            return new View("No POIs found!", Response::HTTP_NOT_FOUND);
        }
        return $result;
    }

    /**
     * @Rest\Get("/api/pois/type")
     * @SWG\Response(
     *     response=200,
     *     description="Returns pois with certain type from database",
     * )
     * *
     * @SWG\Parameter(
     *     name="type",
     *     in="query",
     *     type="integer",
     *     description="ID of poi type whose pois you want to see"
     * )
     * @SWG\Tag(name="poisByType")
     */
    public function getByType(Request $request)
    {
        $type = $request->query->get('type');
        $em = $this->getDoctrine()->getManager();
        $query = $em->createQueryBuilder()
            ->select('p')
            ->from('AppBundle:Poi','p')
            ->where('p.type = :type')
            ->setParameter(":type", $type)
            ->getQuery();

        $result = $query->getResult();
        if ($result === null || count($result) === 0) {
            return new View("No POIs found!", Response::HTTP_NOT_FOUND);
        }
        return $result;
    }
}