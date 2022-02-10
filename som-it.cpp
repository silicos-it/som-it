/*******************************************************************************
som-it.cpp - Som-it
 
Copyright 2012-2013 by Silicos-it, a division of Imacosi BVBA
 
This file is part of Som-it.

	Som-it is free software: you can redistribute it and/or modify
	it under the terms of the GNU Lesser General Public License as published 
	by the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	Som-it is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU Lesser General Public License for more details.

	You should have received a copy of the GNU Lesser General Public License
	along with Som-it.  If not, see <http://www.gnu.org/licenses/>.

***********************************************************************/

#include <iostream>
#include <math.h>
#include <cstdlib>



unsigned index_at_minimum(double*, unsigned n);



int main(int argc, const char * argv[])
{
   std::string line;
   
   // Read SOM
   std::getline(std::cin, line);
   unsigned somrows = atoi(line.c_str());
   double** som = new double*[somrows];
   std::getline(std::cin, line);
   unsigned somcols = atoi(line.c_str());
   for (unsigned i(0); i < somrows; ++i)
   {
      som[i] = new double[somcols];
   }
   for (unsigned c(0); c < somcols; ++c)
   {
      for (unsigned r(0); r < somrows; ++r)
      {
         std::getline(std::cin, line);
         som[r][c] = atof(line.c_str());
      }
   }
   
   // Read matrix
   std::getline(std::cin, line);
   unsigned matrixrows = atoi(line.c_str());
   double** matrix = new double*[matrixrows];
   std::getline(std::cin, line);
   unsigned matrixcols = atoi(line.c_str());
   for (unsigned i(0); i < matrixrows; ++i)
   {
      matrix[i] = new double[matrixcols];
   }
   for (unsigned c(0); c < matrixcols; ++c)
   {
      for (unsigned r(0); r < matrixrows; ++r)
      {
         std::getline(std::cin, line);
         matrix[r][c] = atof(line.c_str());
      }
   }
   
   // For each row of matrix, find closest cell in SOM
   double* distance2cell = new double[somrows];
   unsigned* counts = new unsigned[somrows];
   for (unsigned i(0); i < somrows; ++i) { counts[i] = 0; }
   unsigned* mappings = new unsigned[matrixrows];
   double* distances = new double[matrixrows];
   unsigned minindex;
   double mms;
   for (unsigned m(0); m < matrixrows; ++m)
   {
      for (unsigned r(0); r < somrows; ++r)
      {
         distance2cell[r] = 0.0;
         for (unsigned i(0); i < matrixcols; ++i)
         {
            mms = matrix[m][i] - som[r][i];
            distance2cell[r] += mms * mms;
         }
      }
      minindex = index_at_minimum(distance2cell, somrows);
      counts[minindex] += 1;
      mappings[m] = minindex + 1;
      distances[m] = distance2cell[minindex];
   }
   
   // Return first the counts, then the mappings and finally the distances to each cell
   for (unsigned i(0); i < somrows; ++i) { std::cout << counts[i] << std::endl; }
   for (unsigned i(0); i < matrixrows; ++i) { std::cout << mappings[i] << std::endl; }
   for (unsigned i(0); i < matrixrows; ++i) { std::cout << sqrt(distances[i]) << std::endl; }
   
   // Clear memory and return
   for (unsigned i(0); i < somrows; ++i) { delete[] som[i]; }; delete[] som;
   for (unsigned i(0); i < matrixrows; ++i) { delete[] matrix[i]; }; delete[] matrix;
   delete[] distance2cell;
   delete[] counts;
   delete[] mappings;
   delete[] distances;
   
   return 0;
}



unsigned index_at_minimum(double* v, unsigned n)
{
   unsigned idx(0);
   double value(v[0]);
   for (unsigned i(1); i < n; ++i)
   {
      if (v[i] < value)
      {
         value = v[i];
         idx = i;
      }
   }
   return idx;
}




