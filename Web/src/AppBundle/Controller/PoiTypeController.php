<?php

namespace AppBundle\Controller;

use AppBundle\Entity\PoiType;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Method;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;use Symfony\Component\HttpFoundation\Request;

/**
 * Poitype controller.
 *
 * @Route("poitype")
 */
class PoiTypeController extends Controller
{
    /**
     * Lists all poiType entities.
     *
     * @Route("/", name="poitype_index")
     * @Method("GET")
     */
    public function indexAction()
    {
        $em = $this->getDoctrine()->getManager();

        $poiTypes = $em->getRepository('AppBundle:PoiType')->findAll();

        return $this->render('poitype/index.html.twig', array(
            'poiTypes' => $poiTypes,
        ));
    }

    /**
     * Creates a new poiType entity.
     *
     * @Route("/new", name="poitype_new")
     * @Method({"GET", "POST"})
     */
    public function newAction(Request $request)
    {
        $poiType = new Poitype();
        $form = $this->createForm('AppBundle\Form\PoiTypeType', $poiType);
        $form->handleRequest($request);

        if ($form->isSubmitted() && $form->isValid()) {
            $em = $this->getDoctrine()->getManager();
            $em->persist($poiType);
            $em->flush();

            return $this->redirectToRoute('poitype_show', array('id' => $poiType->getId()));
        }

        return $this->render('poitype/new.html.twig', array(
            'poiType' => $poiType,
            'form' => $form->createView(),
        ));
    }

    /**
     * Finds and displays a poiType entity.
     *
     * @Route("/{id}", name="poitype_show")
     * @Method("GET")
     */
    public function showAction(PoiType $poiType)
    {
        $deleteForm = $this->createDeleteForm($poiType);

        return $this->render('poitype/show.html.twig', array(
            'poiType' => $poiType,
            'delete_form' => $deleteForm->createView(),
        ));
    }

    /**
     * Displays a form to edit an existing poiType entity.
     *
     * @Route("/{id}/edit", name="poitype_edit")
     * @Method({"GET", "POST"})
     */
    public function editAction(Request $request, PoiType $poiType)
    {
        $deleteForm = $this->createDeleteForm($poiType);
        $editForm = $this->createForm('AppBundle\Form\PoiTypeType', $poiType);
        $editForm->handleRequest($request);

        if ($editForm->isSubmitted() && $editForm->isValid()) {
            $this->getDoctrine()->getManager()->flush();

            return $this->redirectToRoute('poitype_edit', array('id' => $poiType->getId()));
        }

        return $this->render('poitype/edit.html.twig', array(
            'poiType' => $poiType,
            'edit_form' => $editForm->createView(),
            'delete_form' => $deleteForm->createView(),
        ));
    }

    /**
     * Deletes a poiType entity.
     *
     * @Route("/{id}", name="poitype_delete")
     * @Method("DELETE")
     */
    public function deleteAction(Request $request, PoiType $poiType)
    {
        $form = $this->createDeleteForm($poiType);
        $form->handleRequest($request);

        if ($form->isSubmitted() && $form->isValid()) {
            $em = $this->getDoctrine()->getManager();
            $em->remove($poiType);
            $em->flush();
        }

        return $this->redirectToRoute('poitype_index');
    }

    /**
     * Creates a form to delete a poiType entity.
     *
     * @param PoiType $poiType The poiType entity
     *
     * @return \Symfony\Component\Form\Form The form
     */
    private function createDeleteForm(PoiType $poiType)
    {
        return $this->createFormBuilder()
            ->setAction($this->generateUrl('poitype_delete', array('id' => $poiType->getId())))
            ->setMethod('DELETE')
            ->getForm()
        ;
    }
}
