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

#include "TigerPermeabilityConst.h"
#include "MooseError.h"

registerMooseObject("TigerApp", TigerPermeabilityConst);

template <>
InputParameters
validParams<TigerPermeabilityConst>()
{
  InputParameters params = validParams<TigerPermeability>();
  MooseEnum PT("isotropic=1 orthotropic=2 anisotropic=3");
  params.addRequiredParam<MooseEnum>("permeability_type", PT,
        "The permeability distribution type [isotropic, orthotropic, anisotropic].");
  params.addRequiredParam<std::vector<Real>>("k0", "Initial permeability (m^2)");

  params.addClassDescription("Permeability tensor based on provided "
        "constant permeability value(s)");
  return params;
}

TigerPermeabilityConst::TigerPermeabilityConst(const InputParameters & parameters)
  : TigerPermeability(parameters)
{
  permeability_type = getParam<MooseEnum>("permeability_type");
  k0.clear();
  k0 = getParam<std::vector<Real>>("k0");
}
