<?php

namespace AppBundle\Entity;

use Doctrine\ORM\Mapping as ORM;

/**
 * NotificationDevice
 *
 * @ORM\Table(name="notification_device")
 * @ORM\Entity(repositoryClass="AppBundle\Repository\NotificationDeviceRepository")
 */
class NotificationDevice
{
    /**
     * @var int
     *
     * @ORM\Column(name="id", type="integer")
     * @ORM\Id
     * @ORM\GeneratedValue(strategy="AUTO")
     */
    private $id;

    /**
     * @var string
     *
     * @ORM\Column(name="apnId", type="text")
     */
    private $apnId;


    /**
     * Get id
     *
     * @return int
     */
    public function getId()
    {
        return $this->id;
    }

    /**
     * Set apnId
     *
     * @param string $apnId
     *
     * @return NotificationDevice
     */
    public function setApnId($apnId)
    {
        $this->apnId = $apnId;

        return $this;
    }

    /**
     * Get apnId
     *
     * @return string
     */
    public function getApnId()
    {
        return $this->apnId;
    }
}

