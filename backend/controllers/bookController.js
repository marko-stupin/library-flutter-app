const Book = require("../models/bookModel");
const mongoose = require("mongoose");

// get all books
const getBooks = async (req, res) => {
  const books = await Book.find({}).sort({ createdAt: -1 });

  res.status(200).json(books);
};

// get a single book
const getBook = async (req, res) => {
  const { id } = req.params;
  if (!mongoose.Types.ObjectId.isValid(id)) {
    return res.status(404).json({ error: "Book does not exist" });
  }

  const book = await Book.findById(id);
  if (!book) {
    return res.status(404).json({ error: "Book does not exist" });
  }

  res.status(200).json(book);
};
// create a new book
const createBook = async (req, res) => {
  const { title, author, copies } = req.body;

  let emptyFields = [];

  if (!title) {
    emptyFields.push("title");
  }
  if (!author) {
    emptyFields.push("author");
  }
  if (!copies) {
    emptyFields.push("copies");
  }
  if (emptyFields.length > 0) {
    return res
      .status(400)
      .json({ error: "Please fill in all the fields", emptyFields });
  }

  // add doc to db
  try {
    const book = await Book.create({ title, author, copies });
    res.status(200).json(book);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

// delete a book
const deleteBook = async (req, res) => {
  const { id } = req.params;
  if (!mongoose.Types.ObjectId.isValid(id)) {
    return res.status(404).json({ error: "Book does not exist" });
  }

  const book = await Book.findByIdAndDelete({ _id: id });
  if (!book) {
    return res.status(404).json({ error: "Book does not exist" });
  }
  res.status(200).json(book);
};

// update a book
const updateBook = async (req, res) => {
  const { id } = req.params;
  if (!mongoose.Types.ObjectId.isValid(id)) {
    return res.status(404).json({ error: "Book does not exist" });
  }

  const book = await Book.findOneAndUpdate(
    { _id: id },
    {
      ...req.body,
    }
  );
  if (!book) {
    return res.status(404).json({ error: "Book does not exist" });
  }
  res.status(200).json(book);
};

module.exports = {
  getBooks,
  getBook,
  createBook,
  deleteBook,
  updateBook,
};
