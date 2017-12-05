<?php


namespace AppBundle\Service;


use Buzz\Browser;
use Doctrine\ORM\EntityManager;
use GuzzleHttp\Client;

class GooglePlacesFetcherService
{
    /**
     * @var Client
     */
    private $client;

    /**
     * GooglePlacesFetcherService constructor.
     * @param Client $client
     */
    public function __construct(Client $client)
    {
        $this->client = $client;
    }

    /**
     * @param $queryParameters
     * @return mixed|\Psr\Http\Message\ResponseInterface
     */
    public function getFromAPI($queryParameters)
    {
        $response = $this->client->request('GET', 'https://maps.googleapis.com/maps/api/place/nearbysearch/json', [
            'query' => $queryParameters
        ]);
        return \GuzzleHttp\json_decode($response->getBody()->getContents(), true);
    }

    /**
     * @param $lat
     * @param $lng
     * @param $radius - Radius in meters
     * @return array
     */
    public function getByGeolocation($lat, $lng, $radius)
    {
        $response = $this->getFromAPI([
            'key' => 'AIzaSyBYuz2HZWdjthly1NlGKqGA-TPsuHms3ZA',
            'location' => $lat . ',' . $lng,
            'radius' => $radius,
        ]);
        if(isset($response['results']) === false) {
            return [];
        }

        $result = $response['results'];
        $depth = 0;
        while(isset($response['next_page_token']) && $depth < 5) {
            $response = $this->getFromAPI([
                'key' => 'AIzaSyBYuz2HZWdjthly1NlGKqGA-TPsuHms3ZA',
                'pagetoken' => $response['next_page_token'],
            ]);
            $result = array_merge($result, $response['results']);
            $depth++;
        }

        return $result;
    }

}