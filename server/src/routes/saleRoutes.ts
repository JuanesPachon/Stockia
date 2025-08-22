import { Router } from "express";
import { createSaleController } from "../controllers/saleControllers.js";
import verifyToken from "../middlewares/validateToken.js";
import { saleValidations } from "../middlewares/validateSale.js";
import errorsIsEmpty from "../middlewares/errorIsEmpty.js";

const router = Router();

router.use(verifyToken);

router.post("/sales", saleValidations, errorsIsEmpty, createSaleController);

export default router;
