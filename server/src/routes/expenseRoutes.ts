import { Router } from "express";
import { 
    getExpensesController, 
    getExpenseController, 
    createExpenseController, 
    editExpenseController, 
    deleteExpenseController 
} from "../controllers/expenseControllers.js";
import verifyToken from "../middlewares/validateToken.js";
import { expenseValidations, editExpenseValidations } from "../middlewares/validateExpense.js";
import errorsIsEmpty from "../middlewares/errorIsEmpty.js";

const router = Router();

router.use(verifyToken);

router.get("/expenses", getExpensesController);
router.get("/expenses/:id", getExpenseController);
router.post("/expenses", expenseValidations, errorsIsEmpty, createExpenseController);
router.patch("/expenses/:id", editExpenseValidations, errorsIsEmpty, editExpenseController);
router.delete("/expenses/:id", deleteExpenseController);

export default router;
