#===============================================================================
# User options
#===============================================================================

COMPILER = gnu
OPTIMIZE = ON
OPENMP   = ON
DEBUG    = OFF
PROFILE  = OFF

#===============================================================================
# Program name & source code list
#===============================================================================

SRC_DIR := src
OBJ_DIR := obj
BIN_DIR := bin

SRC := $(wildcard $(SRC_DIR)/*.c)
OBJ := $(SRC:$(SRC_DIR)/%.c=$(OBJ_DIR)/%.o)
EXE := $(BIN_DIR)/mintally

#===============================================================================
# Set flags
#===============================================================================

# Standard flags
CFLAGS := -std=gnu99 -Wall -Iinclude

# Linker flags
LDFLAGS := -lm

# GCC compiler
ifeq ($(COMPILER),gnu)
  CC = gcc
  CFLAGS += -flto
  ifeq ($(OPENMP),ON)
    CFLAGS += -fopenmp -DOPENMP
  endif
endif

# Intel compiler
ifeq ($(COMPILER),intel)
  CC = icc
  CFLAGS += -ipo
  ifeq ($(OPENMP),ON)
    CFLAGS += -qopenmp -DOPENMP
  endif
endif

# Debug flags
ifeq ($(DEBUG),ON)
  CFLAGS += -g
  LDFLAGS  += -g
endif

# Profiling flags
ifeq ($(PROFILE),ON)
  CFLAGS += -pg
  LDFLAGS  += -pg
endif

# Optimization flags
ifeq ($(OPTIMIZE),ON)
  CFLAGS += -O3
endif

#===============================================================================
# Targets to build
#===============================================================================

.PHONY: all clean

all: $(EXE)

$(EXE): $(OBJ) | $(BIN_DIR)
	$(CC) $(CFLAGS) $^ $(LDFLAGS) -o $@

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c | $(OBJ_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(BIN_DIR) $(OBJ_DIR):
	mkdir -p $@

clean:
	@$(RM) -rv $(BIN_DIR) $(OBJ_DIR)

-include $(OBJ:.o=.d)
