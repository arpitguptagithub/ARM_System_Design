// Date-Time Library


// Returns the number of days in a month for a given year and month
int daysInMonth(int year, int month) {
    int days;
    IF (month == 1) {   // January
        days = 31;
    }
    ELSE IF (month == 2) {   // February
        IF ((year % 4 == 0 AND year % 100 != 0) OR (year % 400 == 0)) {
            days = 29;   // Leap year
        } ELSE {
            days = 28;
        }
    }
    ELSE IF (month == 3) {   // March
        days = 31;
    }
    ELSE IF (month == 4) {   // April
        days = 30;
    }
    ELSE IF (month == 5) {   // May
        days = 31;
    }
    ELSE IF (month == 6) {   // June
        days = 30;
    }
    ELSE IF (month == 7) {   // July
        days = 31;
    }
    ELSE IF (month == 8) {   // August
        days = 31;
    }
    ELSE IF (month == 9) {   // September
        days = 30;
    }
    ELSE IF (month == 10) {   // October
        days = 31;
    }
    ELSE IF (month == 11) {   // November
        days = 30;
    }
    ELSE IF (month == 12) {   // December
        days = 31;
    }
    RETURN days;
}

// Converts a given date (day, month, year) to a "day of year"
int dayOfYear(int day, int month, int year) {
    int days = 0;
    FOR (int i = 1; i < month; i = i + 1) {
        days = days + daysInMonth(year, i);
    }
    days = days + day;
    RETURN days;
}

// Checks if the given year is a leap year
int isLeapYear(int year) {
    IF ((year % 4 == 0 AND year % 100 != 0) OR (year % 400 == 0)) {
        RETURN 1; // Leap year
    }
    RETURN 0; // Not a leap year
}

// Returns the number of days in a year
int daysInYear(int year) {
    IF (isLeapYear(year) == 1) {
        RETURN 366; // Leap year
    }
    RETURN 365; // Regular year
}

// Converts a given "day of year" to a date (day, month, year)
void dayOfYearToDate(int dayOfYear, int year, int *day, int *month) {
    int days = 0;
    FOR (int m = 1; m <= 12; m = m + 1) {
        int daysInThisMonth = daysInMonth(year, m);
        IF (days + daysInThisMonth >= dayOfYear) {
            *month = m;
            *day = dayOfYear - days;
            RETURN;
        }
        days = days + daysInThisMonth;
    }
    *day = -1; // Error, invalid dayOfYear
    *month = -1;
}



// Converts time (hour, minute, second) into total seconds since midnight
int timeToSeconds(int hour, int minute, int second) {
    int totalSeconds = (hour * 3600) + (minute * 60) + second;
    RETURN totalSeconds;
}

// Converts total seconds since midnight into hours, minutes, and seconds
void secondsToTime(int totalSeconds, int *hour, int *minute, int *second) {
    *hour = totalSeconds / 3600;
    totalSeconds = totalSeconds % 3600;
    *minute = totalSeconds / 60;
    *second = totalSeconds % 60;
    RETURN;
}

// Adds a given number of seconds to a given time (hour, minute, second)
void addSecondsToTime(int *hour, int *minute, int *second, int secondsToAdd) {
    int totalSeconds = timeToSeconds(*hour, *minute, *second) + secondsToAdd;
    secondsToTime(totalSeconds, hour, minute, second);
    RETURN;
}

// Subtracts a given number of seconds from a given time (hour, minute, second)
void subtractSecondsFromTime(int *hour, int *minute, int *second, int secondsToSubtract) {
    int totalSeconds = timeToSeconds(*hour, *minute, *second) - secondsToSubtract;
    secondsToTime(totalSeconds, hour, minute, second);
    RETURN;
}

// Converts a given date (day, month, year) to the number of days since a base date (e.g., 1st Jan 1970)
int dateToDays(int day, int month, int year) {
    int days = 0;
    FOR (int y = 1970; y < year; y = y + 1) {
        days = days + daysInYear(y);
    }
    FOR (int m = 1; m < month; m = m + 1) {
        days = days + daysInMonth(year, m);
    }
    days = days + day;
    RETURN days;
}

// Adds a number of days to a given date (day, month, year)
void addDaysToDate(int *day, int *month, int *year, int daysToAdd) {
    int totalDays = dateToDays(*day, *month, *year) + daysToAdd;
    int newYear = 1970;
    WHILE (totalDays >= daysInYear(newYear)) {
        totalDays = totalDays - daysInYear(newYear);
        newYear = newYear + 1;
    }
    *year = newYear;
    dayOfYearToDate(totalDays, *year, day, month);
    RETURN;
}

// Subtracts a number of days from a given date (day, month, year)
void subtractDaysFromDate(int *day, int *month, int *year, int daysToSubtract) {
    int totalDays = dateToDays(*day, *month, *year) - daysToSubtract;
    int newYear = 1970;
    WHILE (totalDays < 0) {
        totalDays = totalDays + daysInYear(newYear);
        newYear = newYear - 1;
    }
    *year = newYear;
    dayOfYearToDate(totalDays, *year, day, month);
    RETURN;
}
