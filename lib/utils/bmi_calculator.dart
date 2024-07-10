class BMICalculator {
  final Person person;

  const BMICalculator(this.person);

  double calculateMaleBMR() {
    return 10 * person.initialWeight +
        6.25 * person.height -
        5 * person.age +
        5;
  }

  double calculateFemaleBMR() {
    return 10 * person.initialWeight +
        6.25 * person.height -
        5 * person.age -
        161;
  }

  double getBMR() {
    if (person.sex == Sex.male) {
      return calculateMaleBMR();
    } else {
      return calculateFemaleBMR();
    }
  }

  double getTdee() {
    double bmr = getBMR();
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

  double getCalorieNeedPerDay() {
    return getTdee();
  }

  double suggestCaloriesPerMeal() {
    return getCalorieNeedPerDay() / 3;
  }

  double getProteinNeedPerDay() {
    return person.initialWeight * 1.8;
  }

  double getFatNeedPerDay() {
    return (getCalorieNeedPerDay() * 0.25) / 9;
  }

  double getCarbNeedPerDay() {
    double totalCalories = getCalorieNeedPerDay();
    double proteinCalories = getProteinNeedPerDay() * 4;
    double fatCalories = getFatNeedPerDay() * 9;
    return (totalCalories - proteinCalories - fatCalories) / 4;
  }

  double getAdditionalCalorieNeedPerDay() {
    if (person.initialWeight < person.expectedWeight) {
      return person.expectedWeightPerDay * 7700 / 7;
    } else {
      return 0;
    }
  }

  double getAdditionalCarbNeedPerDay() {
    return getAdditionalCalorieNeedPerDay() / 4;
  }

  double getAdditionalProteinNeedPerDay() {
    return getAdditionalCalorieNeedPerDay() * 0.3 / 4;
  }

  double getAdditionalFatNeedPerDay() {
    return getAdditionalCalorieNeedPerDay() * 0.2 / 9;
  }

  double getTotalCalorieNeedPerDay() {
    return getCalorieNeedPerDay() + getAdditionalCalorieNeedPerDay();
  }

  double getTotalCarbNeedPerDay() {
    return getCarbNeedPerDay() + getAdditionalCarbNeedPerDay();
  }

  double getTotalProteinNeedPerDay() {
    return getProteinNeedPerDay() + getAdditionalProteinNeedPerDay();
  }

  double getTotalFatNeedPerDay() {
    return getFatNeedPerDay() + getAdditionalFatNeedPerDay();
  }

  double remainingCalorieNeedPerDay(double completedCaloriesPerDay) {
    return getTotalCalorieNeedPerDay() - completedCaloriesPerDay;
  }

  double remainingCarbNeedPerDay(double completedCarbPerDay) {
    return getTotalCarbNeedPerDay() - completedCarbPerDay;
  }

  double remainingFatNeedPerDay(double completedFatPerDay) {
    return getTotalFatNeedPerDay() - completedFatPerDay;
  }

  double remainingProteinNeedPerDay(double completedProteinPerDay) {
    return getTotalProteinNeedPerDay() - completedProteinPerDay;
  }

  double remainingCaloriePercentage(double completedCaloriesPerDay) {
    return completedCaloriesPerDay / getTotalCalorieNeedPerDay();
  }

  double remainingCarbPercentage(double completedCarbPerDay) {
    return completedCarbPerDay / getTotalCarbNeedPerDay();
  }

  double remainingFatPercentage(double completedFatPerDay) {
    return completedFatPerDay / getTotalFatNeedPerDay();
  }

  double remainingProteinPercentage(double completedProteinPerDay) {
    return completedProteinPerDay / getTotalProteinNeedPerDay();
  }

  double getWeightChange(double caloricIntake, int days) {
    double dailyCaloricSurplus = caloricIntake - getCalorieNeedPerDay();
    return dailyCaloricSurplus * days / 7700; // 1 kg of fat = 7700 kcal
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
