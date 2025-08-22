import { Router } from "express";
import { 
    getSalesController, 
    getSaleController, 
    createSaleController 
} from "../controllers/saleControllers.js";
import verifyToken from "../middlewares/validateToken.js";
import { saleValidations } from "../middlewares/validateSale.js";
import errorsIsEmpty from "../middlewares/errorIsEmpty.js";

const router = Router();

router.use(verifyToken);

router.get("/sales", getSalesController);
router.get("/sales/:id", getSaleController);
router.post("/sales", saleValidations, errorsIsEmpty, createSaleController);

export default router;
