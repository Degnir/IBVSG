using UnityEngine;
using System;
using System.Collections.Generic;

namespace IBVSG
{
	public class WaypointManager
	{
		public List<GameObject> Waypoints;
		private int _CurrWaypointIndex;

		public WaypointManager (List<GameObject> waypoints)
		{
			_CurrWaypointIndex = 0;
			Waypoints = waypoints;
		}

		public void NextWaypoint()
		{
			_CurrWaypointIndex++;
		}

		public Vector3 CurrWaypointPosition()
		{
			return Waypoints[_CurrWaypointIndex].transform.position;
		}
	}
}

