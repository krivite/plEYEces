<?php

namespace AppBundle\Entity;

use Doctrine\ORM\Mapping as ORM;
use Doctrine\Common\Collections\ArrayCollection;
use JsonSerializable;

/**
 * @ORM\Entity(repositoryClass="AppBundle\Repository\PoiRepository")
 * @ORM\Table(name="pois")
 */
class Poi implements JsonSerializable
{
    /**
     * @ORM\Column(name="poi_id", type="string", length=255)
     * @ORM\Id
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
     * @ORM\Column(name="latitude", type="float")
     */
    private $latitude;

    /**
     * @ORM\Column(name="longitude", type="float")
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
     * @ORM\Column(name="workingHours", type="text")
     */
    private $workingHours;

    /**
     * @ORM\ManyToOne(targetEntity="PoiType", inversedBy="pois")
     * @ORM\JoinColumn(name="poi_type_id", referencedColumnName="poi_type_id")
   
     */
    private $type;

    /**
     * @ORM\ManyToOne(targetEntity="User", inversedBy="pois")
     * @ORM\JoinColumn(name="user_id", referencedColumnName="id")

     */
    private $userId;

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
     * @return string
     */
    public function getId()
    {
        return $this->id;
    }

    /**
     * @param mixed $id
     */
    public function setId($id)
    {
        $this->id = $id;
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

    public function addOffer(Offer $offer)
    {
        if($this->offers->contains($offer))
        {
            return;
        }

        $this->offers[] = $offer;
        $offer->setPoi($this);
    }

    public function jsonSerialize() {
        return [
            "id" => $this->id,
            "name" => $this->name,
            "address" => $this->address,
            "latitude" => $this->latitude,
            "longitude" => $this->longitude,
            "details" => $this->details,
            "image" => $this->image,
            "working_hours" => $this->workingHours,
            "type" => $this->type,
            "offers" => $this->offers->toArray()
        ];
    }
    public function __toString()
    {
        return $this->getName();
    }

    /**
     * @return mixed
     */
    public function getUserId()
    {
        return $this->userId;
    }

    /**
     * @param mixed $userId
     */
    public function setUserId($userId)
    {
        $this->userId = $userId;
    }
}