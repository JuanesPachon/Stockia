import { Router } from "express";
import { createCategoryController, deleteCategoryController, getCategoriesController, getCategoryController, updateCategoryController } from "../controllers/categoryControllers.js";
import verifyToken from "../middlewares/validateToken.js";
import { categoryValidations } from "../middlewares/validateCategory.js";
import errorsIsEmpty from "../middlewares/errorIsEmpty.js";

const router = Router();

router.use(verifyToken);

router.get("/categories", getCategoriesController);
router.get("/categories/:id", getCategoryController);
router.post("/categories", categoryValidations, errorsIsEmpty ,createCategoryController);
router.put("/categories/:id", updateCategoryController);
router.delete("/categories/:id", deleteCategoryController);

export default router;