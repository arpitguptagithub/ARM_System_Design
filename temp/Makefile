CXX = g++
CXXFLAGS = -std=c++11 -Wall

# Target executable
TARGET = os_simulation

# Source files
SRCS = process.cpp

# Object files
OBJS = $(SRCS:.cpp=.o)

# Default target
all: $(TARGET)

$(TARGET): $(OBJS)
	$(CXX) $(OBJS) -o $(TARGET)

# Clean target
clean:
	rm -f $(OBJS) $(TARGET)

# Compile source files
%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $<
