using System;
namespace IBVSG
{
	public static class TweakingVariables
	{
		public static class BeamProps
		{
			public static float Speed = 2.0f;
			public static float Damage = 15.0f;
			public static float Cooldown = 0.5f;
		}

		public static class SuperBeamProps
		{
			public static float Speed = 5.0f;
			public static float Damage = 50.0f;
			public static float Cooldown = 0.1f;
		}
		
		public static class StoneProps
		{
			public static float Speed = 0.8f;
			public static float Damage = 20.0f;
			public static float Cooldown = 1.8f;
		}

		public static class PlayerProps
		{
			public static float Speed = 0.016f;
		}

		public static class SpotProps
		{
			public static float SpawTime = 10.0f;
		}

		public static class PlayerStats
		{
			public static float StartYPos;
			public static int PointsFromKills = 0;
			public static float Health = 100.0f;
			public static int Points = 0;
			public static int High = 0;
		}

		public static void RestartStatic()
		{
			PlayerProps.Speed = 0.016f;
			PlayerStats.StartYPos = 0;
			PlayerStats.Points = 0;
			PlayerStats.High = 0;
			PlayerStats.PointsFromKills = 0;

			StoneProps.Speed = 0.8f;
			StoneProps.Damage = 20.0f;
			StoneProps.Cooldown = 1.8f;
			SpotProps.SpawTime = 10.0f;
		}

		public static void StatsUp()
		{
			PlayerProps.Speed *= 1.2f;
			StoneProps.Speed *= 1.3f;
			StoneProps.Damage += 2.0f;
			StoneProps.Cooldown *= 0.9f;
			SpotProps.SpawTime *= 0.7f;
		}
	}
}

