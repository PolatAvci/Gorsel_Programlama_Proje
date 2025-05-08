using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using ProjeBackend.Models;

namespace ProjeBackend.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class QuestionsController : ControllerBase
    {
        private readonly ApiDbContext _context;

        public QuestionsController(ApiDbContext context)
        {
            _context = context;
        }

        // GET: https://localhost:7176/api/questions
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Question>>> GetAll(int? Difficulty)
        {
            var questionsQuery = _context.Questions.AsQueryable();

            if (Difficulty.HasValue)
            {
                questionsQuery = questionsQuery.Where(q => q.Difficulty == Difficulty.Value);
            }

            return await questionsQuery.ToListAsync();
        }

        // GET: https://localhost:7176/api/questions/categories
        [HttpGet("categories")]
        public async Task<ActionResult<IEnumerable<string>>> GetCategories()
        {
            return await _context.Questions
                                    .Select(q => q.Category)
                                    .Distinct()
                                    .ToListAsync();
        }

        // GET: https://localhost:7176/api/questions/by-category/{category}
        [HttpGet("by-category/{category}")]
        public async Task<ActionResult<IEnumerable<Question>>> GetByCategory(string category, int? Difficulty)
        {
            var query = _context.Questions.Where(q => q.Category.ToLower() == category.ToLower());

            if (Difficulty.HasValue)
            {
                query = query.Where(q => q.Difficulty == Difficulty.Value);
            }

            var list = await query.ToListAsync();

            if (!list.Any())
            {
                var availableCategories = await _context.Questions
                    .Select(q => q.Category)
                    .Distinct()
                    .Where(c => c != null)
                    .ToListAsync();

                return NotFound($"\"{category}\" kategorisinde soru bulunamadı. Mevcut kategoriler: {string.Join(", ", availableCategories)}");
            }

            return list;
        }

        // POST: https://localhost:7176/api/questions
        [HttpPost]
        public async Task<ActionResult<Question>> Create(Question question)
        {
            // Validasyon: Difficulty değeri kontrolü
            if (question.Difficulty < 1 || question.Difficulty > 5)
            {
                return BadRequest("Difficulty değeri 1 ile 5 arasında olmalıdır.");
            }

            _context.Questions.Add(question);
            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(GetAll), new { id = question.Id }, question);
        }

        // PUT: https://localhost:7176/api/questions/{id}
        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, Question question)
        {
            if (id != question.Id)
            {
                return BadRequest();
            }

            // Validasyon: Difficulty değeri kontrolü
            if (question.Difficulty < 1 || question.Difficulty > 5)
            {
                return BadRequest("Difficulty değeri 1 ile 5 arasında olmalıdır.");
            }

            _context.Entry(question).State = EntityState.Modified;
            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!QuestionExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        // DELETE: https://localhost:7176/api/questions/{id}
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var question = await _context.Questions.FindAsync(id);
            if (question == null)
            {
                return NotFound();
            }

            _context.Questions.Remove(question);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool QuestionExists(int id)
        {
            return _context.Questions.Any(e => e.Id == id);
        }
    }
}
