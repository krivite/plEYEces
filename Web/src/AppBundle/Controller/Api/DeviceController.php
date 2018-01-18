<?php

namespace AppBundle\Controller\Api;

use AppBundle\Entity;
use FOS\RestBundle\Controller\FOSRestController;
use FOS\RestBundle\Controller\Annotations as Rest;
use Symfony\Component\HttpFoundation\Response;
use Nelmio\ApiDocBundle\Annotation\Model;
use Swagger\Annotations as SWG;
use FOS\RestBundle\View\View;
use Symfony\Component\HttpFoundation\Request;
use Doctrine\ORM\Mapping as ORM;

class DeviceController extends FOSRestController
{
    /**
     * @Rest\Post("/api/device")
     * @SWG\Response(
     *     response=200,
     *     description="Successfully saved the device ID in the database",
     * )
     * @SWG\Parameter(
     *     in="formData",
     *     name="apn_id",
     *     type="string",
     *     description="APN ID of the device you want to register"
     * )
     * @SWG\Tag(name="register_device")
     */
    public function addDevice(Request $request)
    {
        try {
            $device = new Entity\NotificationDevice();
            $device->setApnId($request->get('apn_id'));
            $em = $this->get('doctrine.orm.entity_manager');
            $em->persist($device);
            $em->flush();
        }
        catch (\Exception $e) {
            return $this->json(['success' => 'false']);
        }

        return $this->json(['success' => 'true']);
    }
}