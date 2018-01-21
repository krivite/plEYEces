<?php


namespace AppBundle\Service;


use Buzz\Browser;
use Doctrine\ORM\EntityManager;
use GuzzleHttp\Client;
use Symfony\Component\DependencyInjection\ContainerInterface as Container;

class GooglePlacesFetcherService
{
    /**
     * @var Client
     */
    private $client;
    private $container;

    /**
     * GooglePlacesFetcherService constructor.
     * @param Client $client
     * @param Container $container
     */
    public function __construct(Client $client, Container $container)
    {
        $this->client = $client;
        $this->container = $container;
    }

    /**
     * @param $queryParameters
     * @param $url
     * @return mixed|\Psr\Http\Message\ResponseInterface
     */
    public function getFromAPI($queryParameters, $url)
    {
        $response = $this->client->request('GET', $url, [
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
        ], 'https://maps.googleapis.com/maps/api/place/nearbysearch/json');
        if(isset($response['results']) === false) {
            return [];
        }

        $result = $response['results'];
        while(isset($response['next_page_token'])) {
            sleep(2);
            $response = $this->getFromAPI([
                'key' => 'AIzaSyBYuz2HZWdjthly1NlGKqGA-TPsuHms3ZA',
                'pagetoken' => $response['next_page_token'],
            ], 'https://maps.googleapis.com/maps/api/place/nearbysearch/json');
            $result = array_merge($result, $response['results']);
        }

        $result = $this->container->get('app.service.poi_filter_service')->createPoiObjects($result);

        return $result;
    }

    /**
     * @param $placeId
     * @return array
     */
    public function getDetails($placeId)
    {
        $response = $this->getFromAPI([
            'key' => 'AIzaSyBYuz2HZWdjthly1NlGKqGA-TPsuHms3ZA',
            'placeid' => $placeId
        ], 'https://maps.googleapis.com/maps/api/place/details/json');

        if(isset($response['result']) === false) {
            return [];
        }

        return $response['result'];
    }

}