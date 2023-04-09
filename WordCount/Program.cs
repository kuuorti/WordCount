using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WordCount
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;

    class Program
    {
        static void Main(string[] args)
        {
            // Проверяем, что переданы аргументы
            if (args.Length == 0)
            {
                Console.WriteLine("Использование: wordcount <input file>");
                return;
            }

            // Считываем файл
            string inputPath = args[0];
            string text = File.ReadAllText(inputPath);

            // Разделяем текст на слова
            string[] words = text.Split(new char[] { ' ', '\r', '\n', '\t' },
                                        StringSplitOptions.RemoveEmptyEntries);

            // Создаем словарь для подсчета количества слов
            Dictionary<string, int> wordCounts = new Dictionary<string, int>();

            // Подсчитываем количество употреблений каждого слова
            foreach (string word in words)
            {
                string cleanedWord = CleanWord(word);
                if (string.IsNullOrEmpty(cleanedWord))
                {
                    continue;
                }

                if (wordCounts.ContainsKey(cleanedWord))
                {
                    wordCounts[cleanedWord]++;
                }
                else
                {
                    wordCounts.Add(cleanedWord, 1);
                }
            }

            // Сортируем слова по убыванию количества употреблений
            var sortedWords = wordCounts.OrderByDescending(x => x.Value);

            // Записываем результаты в файл
            string outputPath = Path.Combine(Path.GetDirectoryName(inputPath), "wordcount.txt");
            using (StreamWriter writer = new StreamWriter(outputPath))
            {
                foreach (var word in sortedWords)
                {
                    writer.WriteLine("{0}\t{1}", word.Key, word.Value);
                }
            }
        }

        static string CleanWord(string word)
        {
            // Удаляем знаки препинания и приводим слово к нижнему регистру
            return new string(word.Where(c => char.IsLetter(c) || char.IsWhiteSpace(c))
                                  .ToArray())
                   .Trim()
                   .ToLower();
        }
    }

}
