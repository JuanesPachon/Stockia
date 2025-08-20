import { Router } from "express";
import { createProviderController } from "../controllers/providerControllers.js";
import verifyToken from "../middlewares/validateToken.js";
import { providerValidations } from "../middlewares/validateProvider.js";
import errorsIsEmpty from "../middlewares/errorIsEmpty.js";

const router = Router();

router.use(verifyToken);

router.post("/providers", providerValidations, errorsIsEmpty, createProviderController);

export default router;
