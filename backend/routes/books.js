const express = require("express");
const {
  getBooks,
  getBook,
  createBook,
  deleteBook,
  updateBook,
} = require("../controllers/bookController");

const router = express.Router();

// GET all books
router.get("/", getBooks);

// GET a single book
router.get("/:id", getBook);

// POST a single book
router.post("/", createBook);

// DELETE a single book
router.delete("/:id", deleteBook);

// UPDATE a single book
router.patch("/:id", updateBook);

module.exports = router;
