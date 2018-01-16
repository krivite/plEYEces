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
}

