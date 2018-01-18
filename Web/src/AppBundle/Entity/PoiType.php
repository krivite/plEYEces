<?php

namespace AppBundle\Entity;

use Doctrine\ORM\Mapping as ORM;
use Doctrine\Common\Collections\ArrayCollection;
use JsonSerializable;
use Symfony\Component\Serializer\Annotation\Groups;


/**
 * PoiType
 *
 * @ORM\Table(name="poi_type")
 * @ORM\Entity(repositoryClass="AppBundle\Repository\PoiTypeRepository")
 */
class PoiType implements JsonSerializable
{
    /**
     * @var int
     *
     * @ORM\Column(name="poi_type_id", type="integer")
     * @ORM\Id
     * @ORM\GeneratedValue(strategy="AUTO")
     */
    private $id;

    /**

     * @var string
     *
     * @ORM\Column(name="name", type="string", length=255)
     */
    private $name;

    /**

     * @var string
     *
     * @ORM\Column(name="places_id", type="string", length=255)
     */
    private $placesId;

    /**

     * @var string
     *
     * @ORM\Column(name="color", type="string", length=7)
     */
    private $color;

    /**

     * @var text
     *
     * @ORM\Column(name="icon", type="text")
     */
    private $icon;





    /**
     * @ORM\OneToMany(targetEntity="Poi", mappedBy="type")
     */
    private $pois;

    public function __construct()
    {
        $this->pois = new ArrayCollection();
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
     * Set name
     *
     * @param string $name
     *
     * @return PoiType
     */
    public function setName($name)
    {
        $this->name = $name;

        return $this;
    }

    /**
     * Get name
     *
     * @return string
     */
    public function getName()
    {
        return $this->name;
    }

    /**
     * @return mixed
     */
    public function getPois()
    {
        return $this->pois;
    }

    /**
     * @param mixed $pois
     */
    public function setPois($pois)
    {
        $this->pois = $pois;
    }

    public function jsonSerialize() {
        return (object) get_object_vars($this);
    }

    /**
     * @return mixed
     */
    public function getColor()
    {
        return $this->color;
    }

    /**
     * @param mixed $color
     * @return PoiType
     */
    public function setColor($color)
    {
        $this->color = $color;
        return $this;
    }

    /**
     * @return mixed
     */
    public function getIcon()
    {
        return $this->icon;
    }

    /**
     * @param mixed $icon
     * @return PoiType
     */
    public function setIcon($icon)
    {
        $this->icon = $icon;
        return $this;
    }

    /**
     * @return string
     */
    public function getPlacesId()
    {
        return $this->placesId;
    }

    /**
     * @param string $placesId
     */
    public function setPlacesId($placesId)
    {
        $this->placesId = $placesId;
    }
}

