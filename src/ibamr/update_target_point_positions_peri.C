#include "update_target_point_positions_peri.h"
#include <ibamr/IBTargetPointForceSpec.h>
#include <ibtk/LData.h>
#include <stdio.h>
#include <stdlib.h>

void update_target_point_positions_peri(
    tbox::Pointer<hier::PatchHierarchy<NDIM> > hierarchy,
    LDataManager* const l_data_manager,
    const double current_time,
    const double dt,
    ParameterFile & pf)
{
  // Find finest grid level number in simulation
  const int finest_ln = hierarchy->getFinestLevelNumber();

    static const double pi = 4*atan(1);
	static const double V = 0.2; //velocity of the wing during translation (meters/sec)
	
	////////////////////////////////////////////////////////////////////////////////////////
	// these parameters require modification to match the desired geometry and motion
	
    static const double L1 = pf.L1; // length of computational domain (meters)
    static const int N1 = pf.N1; // number of cartesian grid meshwidths at the finest level of the AMR grid
    static const double ds = L1/(2.0*N1);
    static const double Let = pf.Let;
    static const double diameter = pf.tdiameter;			// diameter of tube
	static const double R2 = pf.tR2;				// distance from middle of domain to inner wall
	static const double R1 = R2+diameter;		// distance from middle of domain to outer wall
	static const double pamp = pf.pamp;				//percent occlusion of the tube
	static const double amp = pamp*diameter/2.0;	//amplitude of contraction of each piece of the actuator
	static const double freq = pf.freq;
        static const double iposn = pf.iposn;
	double s_ramp = 0.5*(1/freq);
	double c_amp;

 ////////////////////////////////////////////////////////////////////////////////////////////////

    // Find out the Lagrangian index ranges.
    const std::pair<int,int>& actuator_top_idxs = l_data_manager->getLagrangianStructureIndexRange(0, finest_ln);
	const std::pair<int,int>& actuator_bot_idxs = l_data_manager->getLagrangianStructureIndexRange(1, finest_ln);

    // Get the LMesh (which we assume to be associated with the finest level of
    // the patch hierarchy).  Note that we currently need to update both "local"
    // and "ghost" node data.
    Pointer<LMesh> mesh = l_data_manager->getLMesh(finest_ln);
    vector<LNode*> nodes;
    nodes.insert(nodes.end(), mesh->getLocalNodes().begin(), mesh->getLocalNodes().end());
    nodes.insert(nodes.end(), mesh->getGhostNodes().begin(), mesh->getGhostNodes().end());

    // Update the target point positions in their associated target point force
    // specs.
    tbox::Pointer<hier::PatchLevel<NDIM> > level = hierarchy->getPatchLevel(finest_ln);
    for (vector<LNode*>::iterator it = nodes.begin(); it != nodes.end(); ++it)
    {
        LNode* node_idx = *it;
        IBTargetPointForceSpec* force_spec = node_idx->getNodeDataItem<IBTargetPointForceSpec>();
    if (force_spec == NULL) continue;  // skip to next node

    const int lag_idx = node_idx->getLagrangianIndex();
	Point& X_target = force_spec->getTargetPointPosition();
	
	if(current_time<s_ramp)
	  {
	    c_amp = current_time/s_ramp;
	  }
	else
	  {c_amp = 1;
	  }
		//move the top piece
	    if (actuator_top_idxs.first <= lag_idx && lag_idx < actuator_top_idxs.second)
	      {
		int ipos = lag_idx-actuator_top_idxs.first;
		X_target[1] = -R2-(amp)*c_amp*(sin(-2*pi*freq*current_time + 2*pi*(ipos*iposn*ds/Let)));
	      }
		//move the bottom piece
		if (actuator_bot_idxs.first <= lag_idx && lag_idx < actuator_bot_idxs.second)
	      {
		int ipos = lag_idx-actuator_bot_idxs.first;
		X_target[1] = -R1+(amp)*c_amp*(sin(-2*pi*freq*current_time + 2*pi*(ipos*iposn*ds/Let)));
	      }
    }
    return;
} //update_target_point_positions_peri
