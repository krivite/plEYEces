<?php

namespace AppBundle\Controller\Api;

use AppBundle\Controller\PoiRestController;
use Symfony\Bundle\FrameworkBundle\Test\WebTestCase;

class PoiRestControllerTest extends WebTestCase
{

    public function testGetAll()
    {
        $client = static::createClient();

        $client->request('GET', '/api/pois');
        $response = $client->getResponse();

        $this->assertEquals(200, $response->getStatusCode());

        $this->assertGreaterThan(
            0,
            \count(json_decode($response->getContent(), true))
        );
    }

    public function testGetAction()
    {
        $client= static::createClient();
        $client->request('GET', '/api/poi/id1');
        $response = $client->getResponse();

        $this->assertEquals(200, $response->getStatusCode());

        $this->assertEquals("id1", json_decode($response->getContent())->id);
    }

    public function testGetAllCategories()
    {
        $client = static::createClient();

        $client->request('GET', '/api/categories');
        $response = $client->getResponse();

        $this->assertEquals(200, $response->getStatusCode());

        $this->assertGreaterThan(
            0,
            \count(json_decode($response->getContent(), true))
        );
    }

    public function testGetAllOffers()
    {
        $client = static::createClient();

        $client->request('GET', '/api/poisWithOffers');
        $response = $client->getResponse();

        $this->assertEquals(200, $response->getStatusCode());

        $this->assertGreaterThan(
            0,
            \count(json_decode($response->getContent(), true))
        );
    }

    public function testGetInRadius()
    {
        $client = static::createClient();

        $client->request('GET', '/api/pois/location?latitude=44&longitude=44&radius=10000"');
        $response = $client->getResponse();

        $this->assertEquals(200, $response->getStatusCode());

    }




}
