class BMICalculator {
  final Person person;

  const BMICalculator(this.person);

  double get male =>
      10 * person.initialWeight + 6.25 * person.height - 5 * person.age + 5;

  double get female =>
      10 * person.initialWeight + 6.25 * person.height - 5 * person.age - 161;

  double get bmr => person.sex == Sex.male ? male : female;

  double get tdee {
    switch (person.activityLevel) {
      case ActivityLevel.sedentary:
        return bmr * 1.2;
      case ActivityLevel.lightlyActive:
        return bmr * 1.375;
      case ActivityLevel.moderatelyActive:
        return bmr * 1.55;
      case ActivityLevel.veryActive:
        return bmr * 1.725;
      case ActivityLevel.superActive:
        return bmr * 1.9;
      default:
        return bmr;
    }
  }

  double get calorieNeedPerDay => tdee;

  double get suggestCaloriesPerMeal => calorieNeedPerDay / 3;

  double get proteinNeedPerDay => person.initialWeight * 1.8;

  double get fatNeedPerDay => (calorieNeedPerDay * 0.25) / 9;

  double get carbNeedPerDay {
    double totalCalories = calorieNeedPerDay;
    double proteinCalories = proteinNeedPerDay * 4;
    double fatCalories = fatNeedPerDay * 9;
    return (totalCalories - proteinCalories - fatCalories) / 4;
  }

  double get additionalCalorieNeedPerDay {
    if (person.initialWeight < person.expectedWeight) {
      return person.expectedWeightPerDay * 7700 / 7;
    } else {
      return 0;
    }
  }

  double get additionalCarbNeedPerDay {
    return additionalCalorieNeedPerDay / 4;
  }

  double get additionalProteinNeedPerDay {
    return additionalCalorieNeedPerDay * 0.3 / 4;
  }

  double get additionalFatNeedPerDay {
    return additionalCalorieNeedPerDay * 0.2 / 9;
  }

  double get totalCalorieNeedPerDay {
    return calorieNeedPerDay + additionalCalorieNeedPerDay;
  }

  double get totalCarbNeedPerDay {
    return carbNeedPerDay + additionalCarbNeedPerDay;
  }

  double get totalProteinNeedPerDay {
    return proteinNeedPerDay + additionalProteinNeedPerDay;
  }

  double get totalFatNeedPerDay => fatNeedPerDay + additionalFatNeedPerDay;

  double remainingCalorieNeedPerDay(double completedCaloriesPerDay) {
    return totalCalorieNeedPerDay - completedCaloriesPerDay;
  }

  double remainingCarbNeedPerDay(double completedCarbPerDay) {
    return totalCarbNeedPerDay - completedCarbPerDay;
  }

  double remainingFatNeedPerDay(double completedFatPerDay) {
    return totalFatNeedPerDay - completedFatPerDay;
  }

  double remainingProteinNeedPerDay(double completedProteinPerDay) {
    return totalProteinNeedPerDay - completedProteinPerDay;
  }

  double remainingCaloriePercentage(double completedCaloriesPerDay) {
    return completedCaloriesPerDay / totalCalorieNeedPerDay;
  }

  double remainingCarbPercentage(double completedCarbPerDay) {
    return completedCarbPerDay / totalCarbNeedPerDay;
  }

  double remainingFatPercentage(double completedFatPerDay) {
    return completedFatPerDay / totalFatNeedPerDay;
  }

  double remainingProteinPercentage(double completedProteinPerDay) {
    return completedProteinPerDay / totalProteinNeedPerDay;
  }

  double getWeightChange(double caloricIntake, int days) {
    double dailyCaloricSurplus = caloricIntake - calorieNeedPerDay;
    return dailyCaloricSurplus * days / 7700;
  }
}

class Person {
  final double initialWeight;
  final double expectedWeight;
  final double expectedWeightPerDay;
  final double height;
  final int age;
  final Sex sex;
  final ActivityLevel activityLevel;
  final Goal goal;

  const Person({
    required this.initialWeight,
    required this.expectedWeight,
    required this.expectedWeightPerDay,
    required this.height,
    required this.age,
    required this.sex,
    required this.activityLevel,
    required this.goal,
  });
}

enum Sex { male, female }

enum ActivityLevel {
  sedentary,
  lightlyActive,
  moderatelyActive,
  extremelyActive,
  veryActive,
  superActive;

  factory ActivityLevel.from(double weight) {
    if (weight < 50) {
      return ActivityLevel.sedentary;
    } else if (weight >= 50 && weight < 65) {
      return ActivityLevel.lightlyActive;
    } else if (weight >= 65 && weight < 80) {
      return ActivityLevel.moderatelyActive;
    } else if (weight >= 80 && weight < 100) {
      return ActivityLevel.veryActive;
    } else {
      return ActivityLevel.superActive;
    }
  }
}

enum Goal { lose, gain, maintain }
