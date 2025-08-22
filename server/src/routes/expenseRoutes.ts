import { Router } from "express";
import { createExpenseController, editExpenseController } from "../controllers/expenseControllers.js";
import verifyToken from "../middlewares/validateToken.js";
import { expenseValidations, editExpenseValidations } from "../middlewares/validateExpense.js";
import errorsIsEmpty from "../middlewares/errorIsEmpty.js";

const router = Router();

router.use(verifyToken);

router.post("/expenses", expenseValidations, errorsIsEmpty, createExpenseController);
router.patch("/expenses/:id", editExpenseValidations, errorsIsEmpty, editExpenseController);

export default router;
