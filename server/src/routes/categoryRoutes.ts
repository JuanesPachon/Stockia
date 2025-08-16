import { Router } from "express";
import { createCategoryController, deleteCategoryController, getCategoriesController, getCategoryController, updateCategoryController } from "../controllers/cateogoryControllers.js";

const router = Router();

router.get("/categories", getCategoriesController);
router.get("/categories/:id", getCategoryController);
router.post("/categories", createCategoryController);
router.put("/categories/:id", updateCategoryController);
router.delete("/categories/:id", deleteCategoryController);

export default router;