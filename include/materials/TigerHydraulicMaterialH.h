/**************************************************************************/
/*  TIGER - THMC sImulator for GEoscience Research                        */
/*                                                                        */
/*  Copyright (C) 2017 by Maziar Gholami Korzani                          */
/*  Karlsruhe Institute of Technology, Institute of Applied Geosciences   */
/*  Division of Geothermal Research                                       */
/*                                                                        */
/*  This file is part of TIGER App                                        */
/*                                                                        */
/*  This program is free software: you can redistribute it and/or modify  */
/*  it under the terms of the GNU General Public License as published by  */
/*  the Free Software Foundation, either version 3 of the License, or     */
/*  (at your option) any later version.                                   */
/*                                                                        */
/*  This program is distributed in the hope that it will be useful,       */
/*  but WITHOUT ANY WARRANTY; without even the implied warranty of        */
/*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the          */
/*  GNU General Public License for more details.                          */
/*                                                                        */
/*  You should have received a copy of the GNU General Public License     */
/*  along with this program.  If not, see <http://www.gnu.org/licenses/>  */
/**************************************************************************/

#ifndef TIGERHYDRAULICMATERIALH_H
#define TIGERHYDRAULICMATERIALH_H

#include "Material.h"
#include "RankTwoTensor.h"
#include "TigerPermeability.h"

class TigerHydraulicMaterialH;

template <>
InputParameters validParams<TigerHydraulicMaterialH>();

class TigerHydraulicMaterialH : public Material
{
public:
  TigerHydraulicMaterialH(const InputParameters & parameters);

protected:
  virtual void computeQpProperties() override;

  // Permeability tensor divided by viscosity (rotated in lowerD)
  MaterialProperty<RankTwoTensor> & _k_vis;
  // Hydraulic time derivative coefficient
  MaterialProperty<Real> & _H_Kernel_dt;
  // Gravity vector
  MaterialProperty<RealVectorValue> & _gravity;
  // Tiger permeability calculater userobject
  const TigerPermeability & _kf_uo;

  // imported props from TigerGeometryMaterial
  const MaterialProperty<Real> & _n;
  const MaterialProperty<RankTwoTensor> & _rot_mat;

  // imported props from TigerFluidMaterial
  const MaterialProperty<Real> & _mu;
  const MaterialProperty<Real> & _beta_f;

private:
  // Gravity activation option
  bool _has_gravity;
  // Gravity vector
  RealVectorValue _g;
  // Compressibility of the solid phase
  Real _beta_s;
};

#endif /* TIGERHYDRAULICMATERIALH_H */