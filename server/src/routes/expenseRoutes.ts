import { Router } from "express";
import { createExpenseController } from "../controllers/expenseControllers.js";
import verifyToken from "../middlewares/validateToken.js";
import { expenseValidations } from "../middlewares/validateExpense.js";
import errorsIsEmpty from "../middlewares/errorIsEmpty.js";

const router = Router();

router.use(verifyToken);

router.post("/expenses", expenseValidations, errorsIsEmpty, createExpenseController);

export default router;
