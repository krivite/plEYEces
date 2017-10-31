<?php

namespace AppBundle\Entity;

use Doctrine\ORM\Mapping as ORM;
use Doctrine\Common\Collections\ArrayCollection;

/**
 * @ORM\Entity(repositoryClass="AppBundle\Repository\PoiRepository")
 * @ORM\Table(name="pois")
 */
class Poi
{
    /**
     * @ORM\Column(name="poi_id", type="integer")
     * @ORM\Id
     * @ORM\GeneratedValue(strategy="AUTO")
     */
    private $id;

    /**
     * @ORM\Column(name="name", type="string", length=100)
     */
    private $name;

    /**
     * @ORM\Column(name="address", type="text")
     */
    private $address;

    /**
     * @ORM\Column(name="latitude", type="decimal")
     */
    private $latitude;

    /**
     * @ORM\Column(name="longitude", type="decimal")
     */
    private $longitude;

    /**
     * @ORM\Column(name="details", type="text")
     */
    private $details;

    /**
     * @ORM\Column(name="image", type="text")
     */
    private $image;

    /**
     * @ORM\Column(name="working_hours", type="text")
     */
    private $workingHours;

    /**
     * @ORM\ManyToOne(targetEntity="PoiType", inversedBy="pois")
     * @ORM\JoinColumn(name="poi_type_id", referencedColumnName="poi_type_id")
     */
    private $type;

    /**
     * @ORM\OneToMany(targetEntity="Offer", mappedBy="poi")
     */
    private $offers;

    public function __construct()
    {
        $this->offers = new ArrayCollection();
    }

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
     * @return string
     */
    public function getName()
    {
        return $this->name;
    }

    /**
     * @param mixed $name
     */
    public function setName($name)
    {
        $this->name = $name;
    }

    /**
     * @return string
     */
    public function getAddress()
    {
        return $this->address;
    }

    /**
     * @param mixed $address
     */
    public function setAddress($address)
    {
        $this->address = $address;
    }

    /**
     * @return double
     */
    public function getLatitude()
    {
        return $this->latitude;
    }

    /**
     * @param mixed $latitude
     */
    public function setLatitude($latitude)
    {
        $this->latitude = $latitude;
    }

    /**
     * @return double
     */
    public function getLongitude()
    {
        return $this->longitude;
    }

    /**
     * @param mixed $longitude
     */
    public function setLongitude($longitude)
    {
        $this->longitude = $longitude;
    }

    /**
     * @return string
     */
    public function getDetails()
    {
        return $this->details;
    }

    /**
     * @param mixed $details
     */
    public function setDetails($details)
    {
        $this->details = $details;
    }

    /**
     * @return string
     */
    public function getImage()
    {
        return $this->image;
    }

    /**
     * @param mixed $image
     */
    public function setImage($image)
    {
        $this->image = $image;
    }

    /**
     * @return mixed
     */
    public function getWorkingHours()
    {
        return $this->workingHours;
    }

    /**
     * @param mixed $workingHours
     */
    public function setWorkingHours($workingHours)
    {
        $this->workingHours = $workingHours;
    }

    /**
     * @return mixed
     */
    public function getType()
    {
        return $this->type;
    }

    /**
     * @param mixed $type
     */
    public function setType($type)
    {
        $this->type = $type;
    }

    /**
     * @return mixed
     */
    public function getOffers()
    {
        return $this->offers;
    }

    /**
     * @param mixed $offers
     */
    public function setOffers($offers)
    {
        $this->offers = $offers;
    }


}