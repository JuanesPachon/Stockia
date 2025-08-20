import { Router } from "express";
import { createProviderController, updateProviderController, deleteProviderController } from "../controllers/providerControllers.js";
import verifyToken from "../middlewares/validateToken.js";
import { providerValidations, editProviderValidations } from "../middlewares/validateProvider.js";
import errorsIsEmpty from "../middlewares/errorIsEmpty.js";

const router = Router();

router.use(verifyToken);

router.post("/providers", providerValidations, errorsIsEmpty, createProviderController);
router.patch("/providers/:id", editProviderValidations, errorsIsEmpty, updateProviderController);
router.delete("/providers/:id", deleteProviderController);

export default router;
