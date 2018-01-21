<?php

namespace AppBundle\Controller;

use AppBundle\Entity\Poi;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Method;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;use Symfony\Component\HttpFoundation\Request;

/**
 * Poi controller.
 *
 * @Route("/poi")
 */
class PoiController extends Controller
{

    private $poiJSONResponse;
    /**
     * Lists all poi entities.
     *
     * @Route("/", name="admin_poi_index")
     * @Method("GET")
     */
    public function indexAction()
    {

        $user = $this->container->get('security.token_storage')->getToken()->getUser();
        $userId = $user->getId();
        $em = $this->getDoctrine()->getEntityManager();
        $sql="select p from AppBundle:Poi as p where p.userId='{$userId}'";
        $pois= $em->createQuery($sql)->getResult();

        return $this->render('poi/index.html.twig', array(
            'pois' => $pois,
        ));
    }

    /**
     * Creates a new poi entity.
     *
     * @Route("/new", name="admin_poi_new")
     * @Method({"GET", "POST"})
     */
    public function newAction(Request $request)
    {
        $poi = new Poi();
        $form = $this->createForm('AppBundle\Form\PoiType', $poi);
        $form->handleRequest($request);

        if ($form->isSubmitted() && $form->isValid()) {
            $em = $this->getDoctrine()->getManager();
            $user = $this->container->get('security.token_storage')->getToken()->getUser();

            $poi->setUserId($user);

            $sql="select count(p) from AppBundle:Poi as p";
            $poiId= $em->createQuery($sql)->getResult();
            $poi->setId("id".(string)$poiId[0][1]);
            $em->persist($poi);
            $em->flush();

            return $this->redirectToRoute('admin_poi_show', array('id' => $poi->getId()));
        }

        return $this->render('poi/new.html.twig', array(
            'poi' => $poi,
            'form' => $form->createView(),
        ));
    }

    /**
     * Finds and displays a poi entity.
     *
     * @Route("/{id}", name="admin_poi_show")
     * @Method("GET")
     */
    public function showAction(Poi $poi)
    {
        $deleteForm = $this->createDeleteForm($poi);

        return $this->render('poi/show.html.twig', array(
            'poi' => $poi,
            'delete_form' => $deleteForm->createView(),
        ));
    }

    /**
     * Displays a form to edit an existing poi entity.
     *
     * @Route("/{id}/edit", name="admin_poi_edit")
     * @Method({"GET", "POST"})
     */
    public function editAction(Request $request, Poi $poi)
    {
        $deleteForm = $this->createDeleteForm($poi);
        $editForm = $this->createForm('AppBundle\Form\PoiType', $poi);
        $editForm->handleRequest($request);

        if ($editForm->isSubmitted() && $editForm->isValid()) {
            $this->getDoctrine()->getManager()->flush();

            return $this->redirectToRoute('admin_poi_edit', array('id' => $poi->getId()));
        }

        return $this->render('poi/edit.html.twig', array(
            'poi' => $poi,
            'edit_form' => $editForm->createView(),
            'delete_form' => $deleteForm->createView(),
        ));
    }

    /**
     * Deletes a poi entity.
     *
     * @Route("/{id}", name="admin_poi_delete")
     * @Method("DELETE")
     */
    public function deleteAction(Request $request, Poi $poi)
    {
        $form = $this->createDeleteForm($poi);
        $form->handleRequest($request);

        if ($form->isSubmitted() && $form->isValid()) {
            $em = $this->getDoctrine()->getManager();
            $em->remove($poi);
            $em->flush();
        }

        return $this->redirectToRoute('admin_poi_index');
    }

    /**
     * Creates a form to delete a poi entity.
     *
     * @param Poi $poi The poi entity
     *
     * @return \Symfony\Component\Form\Form The form
     */
    private function createDeleteForm(Poi $poi)
    {
        return $this->createFormBuilder()
            ->setAction($this->generateUrl('admin_poi_delete', array('id' => $poi->getId())))
            ->setMethod('DELETE')
            ->getForm()
        ;
    }
}
