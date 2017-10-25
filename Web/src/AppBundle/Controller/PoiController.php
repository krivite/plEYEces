<?php

namespace AppBundle\Controller;

use FOS\RestBundle\Controller\FOSRestController;
use FOS\RestBundle\Controller\Annotations as Rest;
use Symfony\Component\HttpFoundation\Response;
use Nelmio\ApiDocBundle\Annotation\Model;
use Swagger\Annotations as SWG;
use FOS\RestBundle\View\View;

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
        if ($result === null || count($result) === 0) {
            return new View("POI not found!", Response::HTTP_NOT_FOUND);
        }
        return $result;
    }
}