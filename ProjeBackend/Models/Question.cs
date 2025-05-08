// Dosya yolu: ProjeBackend/Models/Question.cs
using System.Collections;
using System.ComponentModel.DataAnnotations;

namespace ProjeBackend.Models
{
    public class Question
    {
        [Key]
        public int Id { get; set; }

        [Required]
      public string? QuestionText { get; set; }

        [Required]
        public string? OptionA { get; set; }
        [Required]
        public string? OptionB { get; set; }
        [Required]
        public string? OptionC { get; set; }
        [Required]
        public string? OptionD { get; set; }

        [Required]
        public int CorrectAnswerIndex { get; set; }

        [Required]
        public string? Category { get; set; }
      
        [Required]
    public int Difficulty { get; set; }
    
            public ICollection<Score>Scores {get;set;}
        
    }
}
