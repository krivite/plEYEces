<?php

namespace AppBundle\Controller\Api;

use AppBundle\Controller\PoiRestController;
use Symfony\Bundle\FrameworkBundle\Test\WebTestCase;

class PoiRestControllerTest extends WebTestCase
{

    public function testGetAll()
    {
        $client = static::createClient();

        $client->request('GET', 'http://localhost:8080/api/pois');
        $response = $client->getResponse();

        $this->assertEquals(200, $response->getStatusCode());

        $this->assertGreaterThan(
            0,
            \count(json_decode($response->getContent(), true))
        );
    }
}
