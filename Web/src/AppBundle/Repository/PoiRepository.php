<?php

namespace AppBundle\Repository;

use Doctrine\ORM\EntityRepository;
use Doctrine\ORM\Query\ResultSetMapping;

class PoiRepository extends EntityRepository
{
    public function findInRadius($radianLongitude, $radianLatitude, $radius)
    {
        $rsm = new ResultSetMapping();
        $rsm->addEntityResult(\AppBundle\Entity\Poi::class, 'p');
        $rsm->addFieldResult('p', 'poi_id', 'id');
        $rsm->addFieldResult('p', 'name', 'name');
        $rsm->addFieldResult('p', 'address', 'address');
        $rsm->addFieldResult('p', 'latitude', 'latitude');
        $rsm->addFieldResult('p', 'longitude', 'longitude');
        $rsm->addFieldResult('p', 'details', 'details');
        $rsm->addFieldResult('p', 'image', 'image');
        $rsm->addFieldResult('p', 'working_hours', 'workingHours');

        return $this->getEntityManager()
            ->createNativeQuery(
                'SELECT * FROM pois p WHERE acos(sin(?) * sin((p.latitude * PI()) / 180)
             + cos(?) * cos((p.latitude * PI()) / 180) 
             * cos((p.longitude * PI()) / 180 - (?))) 
             * 6371 <= ?', $rsm)
            ->setParameter(1, $radianLongitude )
            ->setParameter(2, $radianLongitude )
            ->setParameter(3, $radianLatitude )
            ->setParameter(4, $radius )
            ->getResult();
    }
}
