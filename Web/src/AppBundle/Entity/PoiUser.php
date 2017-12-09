<?php

namespace AppBundle\Entity;

use Doctrine\ORM\Mapping as ORM;

/**
 * PoiUser
 *
 * @ORM\Table(name="poi_user_delete_this")
 * @ORM\Entity(repositoryClass="AppBundle\Repository\PoiUserRepository")
 */
class PoiUser
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
     * @var int
     *
     * @ORM\Column(name="userId", type="integer")
     */
    private $userId;

    /**
     * @var int
     *
     * @ORM\Column(name="poiId", type="integer")
     */
    private $poiId;


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
     * Set userId
     *
     * @param integer $userId
     *
     * @return PoiUser
     */
    public function setUserId($userId)
    {
        $this->userId = $userId;

        return $this;
    }

    /**
     * Get userId
     *
     * @return int
     */
    public function getUserId()
    {
        return $this->userId;
    }

    /**
     * Set poiId
     *
     * @param integer $poiId
     *
     * @return PoiUser
     */
    public function setPoiId($poiId)
    {
        $this->poiId = $poiId;

        return $this;
    }

    /**
     * Get poiId
     *
     * @return int
     */
    public function getPoiId()
    {
        return $this->poiId;
    }
}

