require('dotenv').config();
const express = require('express');
const OpenAI = require('openai');

const app = express();
app.use(express.json());

// Initialize OpenAI API client directly with API key
const openai = new OpenAI.Api({
  apiKey: process.env.OPENAI_API_KEY,
});

app.post('/chat', async (req, res) => {
  try {
    const { prompt } = req.body;
    const gptResponse = await openai.Completions.create({
      model: "text-davinci-003",
      prompt: prompt,
      temperature: 0.7,
      max_tokens: 150,
    });

    res.json({
      response: gptResponse.data.choices[0].text.trim(),
    });
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ message: 'Error processing your request' });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});