from fastapi import FastAPI
from pydantic import BaseModel

class AnalyzeRequest(BaseModel):
    text: str

app = FastAPI(title="Insight-Agent", version="0.1")

@app.post("/analyze")
async def analyze(req: AnalyzeRequest):
    text = req.text or ""
    words = text.split()
    word_count = len(words)
    character_count = len(text)
    return {
        "original_text": text,
        "word_count": word_count,
        "character_count": character_count
    }
