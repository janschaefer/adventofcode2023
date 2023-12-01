#include <stdio.h>
#include <string.h>

int is_number(char c) {
  return (c >= '0' && c <= '9');
}

void replace_number(char *original, char *target, char* numberText, char* number) {
  char *substring = NULL;
  char *search = original;
  int pos = 0;
  do {
    substring = strstr(search, numberText);
    pos = substring - original;
    if (substring != NULL) {
      
       strncpy(target + pos, number, 1);
    }
    search = search + 1;
  }
  while (substring != NULL);
}

char* replace_numbers(char *original) {

  char* target = (char*)malloc(strlen(original) + 1);
  strcpy(target, original);

  replace_number(original, target, "one", "1");
  replace_number(original, target, "two", "2");
  replace_number(original, target, "three", "3");
  replace_number(original, target, "four", "4");
  replace_number(original, target, "five", "5");
  replace_number(original, target, "six", "6");
  replace_number(original, target, "seven", "7");
  replace_number(original, target, "eight", "8");
  replace_number(original, target, "nine", "9");

  return target;
}

int get_calibration_value(const char *str) {
  int result = 0;
  int first = -1;
  int last = -1;
  for (int i = 0; str[i] != '\0'; i++) {
    char c = str[i];
    if (is_number(c)) {
      if (first == -1) {
        first = c - '0';
      }
      last = c - '0';
    }
  }


  return first * 10 + last;

}

void solve1(const char *filename) {
  FILE *file = fopen(filename, "r");
  int sum = 0;
  if (file) {
    char line[100];
    while (fgets(line, sizeof(line), file)) {
      int value = get_calibration_value(line);
      sum = sum + value;
    }
    printf("%d\n", sum); 
    fclose(file);
  }
}

void solve2(const char *filename) {
  FILE *file = fopen(filename, "r");
  char* target = NULL;
  int sum = 0;
  if (file) {
    char line[100];
    while (fgets(line, sizeof(line), file)) {
      target = replace_numbers(line);
      int value = get_calibration_value(target);
      sum = sum + value;
    }
    printf("%d\n", sum); 
    fclose(file);
  }
}

int main(void) {
 solve2("input2");
 return 0;
}

