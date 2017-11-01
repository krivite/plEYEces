<?php

namespace AppBundle\Controller;

use AppBundle\Entity\Offer;
use AppBundle\Entity\Poi;
use AppBundle\Entity\PoiType;
use FOS\RestBundle\Controller\FOSRestController;
use FOS\RestBundle\Controller\Annotations as Rest;
use FOS\RestBundle\View\View;
use Symfony\Component\HttpFoundation\Response;


class DummyControler extends FOSRestController
{

    /**
     * @Rest\Get("/api/dummy")
     */
    public function insertDummy()
    {
        $em = $this->getDoctrine()->getManager();

        $qb = $em->createQueryBuilder();
        $qb->select('count(pois.id)');
        $qb->from(Poi::class,'pois');

        $count = $qb->getQuery()->getSingleScalarResult();

        if($count == 0)
        {
            $this->insertPoiType($em);
            $this->insertPoi($em);
            $this->insertOffer($em);

            $em->flush();

            return "Success";
        }
        return "You already have some data!";
    }

    private function insertPoiType($em)
    {
        $poiType = new PoiType();
        $poiType->setName("Restoran");

        $em->persist($poiType);

        $poiType = new PoiType();
        $poiType->setName("Kafić");

        $em->persist($poiType);

        $poiType = new PoiType();
        $poiType->setName("Butik");

        $em->persist($poiType);

        $poiType = new PoiType();
        $poiType->setName("Dućan");

        $em->persist($poiType);

        $poiType = new PoiType();
        $poiType->setName("Klub");

        $em->persist($poiType);

        $poiType = new PoiType();
        $poiType->setName("Pekara");
    }

    private function insertPoi($em)
    {

        $kafic = $em->getRepository(PoiType::class)->findOneByName("Restoran");
        $restoran = $em->getRepository(PoiType::class)->findOneByName("Kafić");
        $poi = new Poi();
        $poi->setName("The Office Bar");
        $poi->setAddress("Trg kralja Tomislava 2, 42000, Varaždin");
        $poi->setDetails("Kafić na korzu");
        $poi->setImage("https://scontent.cdninstagram.com/t51.2885-15/e35/14156605_1861358474083745_516665513_n.jpg");
        $poi->setLatitude(46.3084084);
        $poi->setLongitude(16.3379735);
        $poi->setWorkingHours("ponedjeljak 08–23, utorak 08–23, srijeda 08–23, četvrtak 08–23, petak 08–01, subota 08–01, nedjelja 08–23");
        $poi->setType($kafic);
        $em->persist($poi);

        $poi = new Poi();
        $poi->setName("My way");
        $poi->setAddress("Trg Miljenka Stančića 1, 42000, Varaždin");
        $poi->setDetails("Kafić kod stančića");
        $poi->setImage("https://www.klikcup.com/images/objects/341/my-way-5.jpg");
        $poi->setLatitude(46.309518);
        $poi->setLongitude(16.335940);
        $poi->setWorkingHours("ponedjeljak 08–23, utorak 08–23, srijeda 08–23, četvrtak 08–23, petak 08–22, subota 08–01, nedjelja 08–23");
        $poi->setType($kafic);
        $em->persist($poi);

        $poi = new Poi();
        $poi->setName("Marex");
        $poi->setAddress("Obala kneza Trpimira 13, 23000, Zadar");
        $poi->setDetails("Kafić na moru");
        $poi->setImage("http://www.zadar.travel/images/original/Plaza_JADRAN_Zadar_Marex_1327676258.jpg");
        $poi->setLatitude(44.122062);
        $poi->setLongitude(15.224328);
        $poi->setWorkingHours("ponedjeljak 08–22, utorak 08–22, srijeda 08–22, četvrtak 08–22, petak 08–22, subota 08–22, nedjelja 08–22");
        $poi->setType($kafic);
        $em->persist($poi);

        $poi = new Poi();
        $poi->setName("Restoran Verglec");
        $poi->setAddress("Ul. Silvija Strahimira Kranjčevića 14, 42000, Varaždin");
        $poi->setDetails("Restoran pokraj muzeja anđela");
        $poi->setImage("http://mura-drava-bike.com/pix/Restoran_Verglec01.jpg");
        $poi->setLatitude(46.309018);
        $poi->setLongitude(16.336654);
        $poi->setWorkingHours("ponedjeljak 10–22, utorak 10–22, srijeda 10–22, četvrtak 10–22, petak 10–22, subota 10–22, nedjelja 10–22");
        $poi->setType($restoran);
        $em->persist($poi);
    }

    private function insertOffer($em)
    {
        $office = $em->getRepository(Poi::class)->findOneByName("The Office Bar");
        $offer = new Offer();
        $offer->setDescription("Kava + Cedevita 15kn");
        $offer->setStartDate(new \DateTime('2017-11-01'));
        $offer->setEndDate(new \DateTime('2017-12-01'));
        $offer->setPoi($office);
        $em->persist($offer);

        $office = $em->getRepository(Poi::class)->findOneByName("My way");
        $offer = new Offer();
        $offer->setDescription("Sok od marelice 12kn");
        $offer->setStartDate(new \DateTime('2017-11-10'));
        $offer->setEndDate(new \DateTime('2017-12-11'));
        $offer->setPoi($office);
        $em->persist($offer);

        $office = $em->getRepository(Poi::class)->findOneByName("Marex");
        $offer = new Offer();
        $offer->setDescription("Karlovačko 10kn");
        $offer->setStartDate(new \DateTime('2017-11-01'));
        $offer->setEndDate(new \DateTime('2018-01-01'));
        $offer->setPoi($office);
        $em->persist($offer);

        $office = $em->getRepository(Poi::class)->findOneByName("Restoran Verglec");
        $offer = new Offer();
        $offer->setDescription("Ručak 1 40kn");
        $offer->setStartDate(new \DateTime('2017-10-21'));
        $offer->setEndDate(new \DateTime('2017-02-11'));
        $offer->setPoi($office);
        $em->persist($offer);
    }
}
