<?php

namespace AppBundle\DataFixtures\ORM;

use AppBundle\Entity\Offer;
use AppBundle\Entity\Poi;
use AppBundle\Entity\PoiType;
use Doctrine\Bundle\FixturesBundle\Fixture;
use Doctrine\Common\Persistence\ObjectManager;

class Fixtures extends Fixture
{

    /**
     * Load data fixtures with the passed EntityManager
     *
     * @param ObjectManager $manager
     */
    public function load(ObjectManager $manager)
    {
        //adding types that match to ones on places api
        $poiType = new PoiType();
        $poiType->setName('Shops');
        $poiType->setColor('#e74c3c');
        $poiType->setIcon('https://i.imgur.com/QIa7sxb.png');
        $manager->persist($poiType);


        $poiType = new PoiType();
        $poiType->setName('Restaurants');
        $poiType->setColor('#1abc9c');
        $poiType->setIcon('https://i.imgur.com/2nVoh20.png');
        $manager->persist($poiType);

        $poiType = new PoiType();
        $poiType->setName('Clubs');
        $poiType->setColor('#9b59b6');
        $poiType->setIcon('https://i.imgur.com/GJDWwN7.png');
        $manager->persist($poiType);

        $poiType = new PoiType();
        $poiType->setName('Caffe bars');
        $poiType->setColor('#e67e22');
        $poiType->setIcon('https://i.imgur.com/JujM5SW.png');
        $manager->persist($poiType);

        $poiType = new PoiType();
        $poiType->setName('Bakeries');
        $poiType->setColor('#f1c40f');
        $poiType->setIcon('https://i.imgur.com/QkQfzJM.png');
        $manager->persist($poiType);



        $manager->flush();

        $poiTypes = $manager->getRepository(PoiType::class)->findAll();
        for ($i = 0; $i < count($poiTypes); $i++ )
        {
            $poi = new Poi();
            $poi->setId("id" . $i);
            $poi->setName($poiTypes[$i]->getName() . " Objekt " . $i);
            $poi->setAddress("Adresa " . $poiTypes[$i]->getName() . " " . $i .", 42000, Varazdin");
            $poi->setDetails("Opis " . $poiTypes[$i]->getName() . " " . $i);
            $poi->setImage("https://scontent.cdninstagram.com/t51.2885-15/e35/14156605_1861358474083745_516665513_n.jpg");
            $poi->setLatitude(46 + (mt_rand(280000, 324000)/1000000));
            $poi->setLongitude(16 + (mt_rand(300000, 375000)/1000000));
            $poi->setWorkingHours("ponedjeljak ". mt_rand(6,12) . "-". mt_rand(20, 24) .
                ", utorak ". mt_rand(6,12) . "-". mt_rand(20, 24) .
                ", srijeda ". mt_rand(6,12) . "-". mt_rand(20, 24) .
                ", četvrtak ". mt_rand(6,12) . "-". mt_rand(20, 24) .
                ", petak ". mt_rand(6,12) . "-". mt_rand(20, 24) .
                ", subota ". mt_rand(6,12) . "-". mt_rand(20, 24) .
                ", nedjelja ". mt_rand(6,12) . "-". mt_rand(20, 24));
            $poi->setType($poiTypes[$i]);
            $manager->persist($poi);
        }
        $manager->flush();

        $pois = $manager->getRepository(Poi::class)->findAll();
        foreach ($pois as $poi) {
            for ($i = 0; $i < 2; $i++) {
                $offer = new Offer();
                $offer->setDescription("Kava " .  mt_rand(5, 15) . "kn");
                $offer->setStartDate(new \DateTime('2017-' . mt_rand(1, 12) . '-' . mt_rand(1, 28)));
                $offer->setEndDate(new \DateTime('2018-' . mt_rand(1, 12) . '-' . mt_rand(1, 28)));
                $offer->setPoi($poi);
                $manager->persist($offer);
            }
        }
        $manager->flush();
    }
}