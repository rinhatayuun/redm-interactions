function IsPedChild(ped)
	return Citizen.InvokeNative(0x137772000DAF42C5, ped)
end

function IsPedAdult(ped)
	return IsPedHuman(ped) and not IsPedChild(ped)
end

function IsPedHumanMale(ped)
	return IsPedHuman(ped) and IsPedMale(ped)
end

function IsPedHumanFemale(ped)
	return IsPedHuman(ped) and not IsPedMale(ped)
end

function IsPedAdultMale(ped)
	return not IsPedChild(ped) and IsPedMale(ped)
end

function IsPedAdultFemale(ped)
	return not IsPedChild(ped) and not IsPedMale(ped)
end

GenericChairs = {
	"mp005_s_posse_col_chair01x",
	"mp005_s_posse_foldingchair_01x",
	"mp005_s_posse_trad_chair01x",
	"p_ambchair01x",
	"p_ambchair02x",
	"p_armchair01x",
	"p_bistrochair01x",
	"p_bench20x",
	"p_benchpiano02x",
	"p_chair02x",
	"p_chair04x",
	"p_chair05x",
	"p_chair06x",
	"p_chair07x",
	"p_chair09x",
	"p_chair_10x",
	"p_chair11x",
	"p_chair12bx",
	"p_chair12x",
	"p_chair13x",
	"p_chair14x",
	"p_chair15x",
	"p_chair16x",
	"p_chair17x",
	"p_chair18x",
	"p_chair19x",
	"p_chair20x",
	"p_chair21x",
	"p_chair21x_fussar",
	"p_chair22x",
	"p_chair23x",
	"p_chair24x",
	"p_chair25x",
	"p_chair26x",
	"p_chair27x",
	"p_chair30x",
	"p_chair31x",
	"p_chair37x",
	"p_chair38x",
	"p_chair_barrel04b",
	"p_chaircomfy01x",
	"p_chaircomfy02",
	"p_chaircomfy03x",
	"p_chaircomfy04x",
	"p_chaircomfy05x",
	"p_chaircomfy06x",
	"p_chaircomfy07x",
	"p_chaircomfy08x",
	"p_chaircomfy09x",
	"p_chaircomfy10x",
	"p_chaircomfy11x",
	"p_chaircomfy12x",
	"p_chaircomfy14x",
	"p_chaircomfy17x",
	"p_chaircomfy18x",
	"p_chaircomfy22x",
	"p_chaircomfy23x",
	"p_chairdoctor01x",
	"p_chair_crate02x",
	"p_chair_crate15x",
	"p_chair_cs05x",
	"p_chairdesk01x",
	"p_chairdesk02x",
	"p_chairdining01x",
	"p_chairdining02x",
	"p_chairdining03x",
	"p_chaireagle01x",
	"p_chairfolding02x",
	"p_chairhob01x",
	"p_chairhob02x",
	"p_chairmed01x",
	"p_chairmed02x",
	"p_chairoffice02x",
	"p_chairpokerfancy01x",
	"p_chairporch01x",
	"p_chair_privatedining01x",
	"p_chairrocking02x",
	"p_chairrocking03x",
	"p_chairrocking04x",
	"p_chairrocking05x",
	"p_chairrocking06x",
	"p_chairrustic01x",
	"p_chairrustic02x",
	"p_chairrustic03x",
	"p_chairrustic04x",
	"p_chairrustic05x",
	"p_chairsalon01x",
	"p_chairvictorian01x",
	"p_chairwhite01x",
	"p_chairwicker01x",
	"p_chairwicker02x",
	"p_cs_electricchair01x",
	"p_diningchairs01x",
	"p_gen_chair07x",
	"p_oldarmchair01x",
	"p_pianochair01x",
	"p_privatelounge_chair01x",
	"p_rockingchair01x",
	"p_rockingchair02x",
	"p_rockingchair03x",
	"p_seatbench01x",
	"p_settee02bx",
	"p_settee03x",
	"p_settee03bx",
	"p_sit_chairwicker01b",
	"p_stool01x",
	"p_stool02x",
	"p_stool03x",
	"p_stool04x",
	"p_stool05x",
	"p_stool06x",
	"p_stool07x",
	"p_stool08x",
	"p_stool09x",
	"p_stool10x",
	"p_stool12x",
	"p_stool13x",
	"p_stool14x",
	"p_stoolcomfy01x",
	"p_stoolcomfy02x",
	"p_stoolfolding01bx",
	"p_stoolfolding01x",
	"p_stoolwinter01x",
	"o_stoolfoldingstatic01x",
	"p_theaterchair01b01x",
	"p_windsorchair01x",
	"p_windsorchair02x",
	"p_windsorchair03x",
	"p_woodbench02x",
	"p_woodendeskchair01x",
	"s_bench01x"
}

GenericBenches = {
	"p_bench03x",
	"p_bench06x",
	"p_bench08bx",
	"p_bench09x",
	"p_bench15_mjr",
	"p_bench15x",
	"p_bench18x",
	"p_benchch01x",
	"p_benchironnbx01x",
	"p_bench_log01x",
	"p_bench_log02x",
	"p_bench_log03x",
	"p_bench_log04x",
	"p_bench_log05x",
	"p_bench_log06x",
	"p_bench_log07x",
	"p_bench_logsnow07x",
	"p_benchnbx02x",
	"p_benchnbx03x",
	"p_couch01x",
	"p_couch02x",
	"p_couch05x",
	"p_couch06x",
	"p_couch08x",
	"p_couch09x",
	"p_couch10x",
	"p_couch11x",
	"p_couchwicker01x",
	"p_hallbench01x",
	"p_loveseat01x",
	"p_settee01x",
	"p_settee04x",
	"p_settee_05x",
	"p_sit_chairwicker01a",
	"p_sofa02x",
	"p_windsorbench01x"
}

GenericChairAndBenchScenarios = {
	{name = "GENERIC_SEAT_BENCH_SCENARIO"},
	{name = "GENERIC_SEAT_CHAIR_SCENARIO", isCompatible = IsPedHumanMale},
	{name = "GENERIC_SEAT_CHAIR_TABLE_SCENARIO"},
	{name = "MP_LOBBY_PROP_HUMAN_SEAT_BENCH_PORCH_DRINKING"},
	{name = "MP_LOBBY_PROP_HUMAN_SEAT_BENCH_PORCH_SMOKING"},
	{name = "MP_LOBBY_PROP_HUMAN_SEAT_CHAIR"},
	{name = "MP_LOBBY_PROP_HUMAN_SEAT_CHAIR_KNIFE_BADASS"},
	{name = "MP_LOBBY_PROP_HUMAN_SEAT_CHAIR_WHITTLE"},
	{name = "PROP_CAMP_FIRE_SEAT_CHAIR"},
	{name = "PROP_HUMAN_CAMP_FIRE_SEAT_BOX"},
	{name = "PROP_HUMAN_SEAT_BENCH_CONCERTINA", isCompatible = IsPedHumanMale},
	{name = "PROP_HUMAN_SEAT_BENCH_FIDDLE", isCompatible = IsPedHumanFemale},
	{name = "PROP_HUMAN_SEAT_BENCH_JAW_HARP", isCompatible = IsPedHumanMale},
	{name = "PROP_HUMAN_SEAT_BENCH_MANDOLIN", isCompatible = IsPedHumanMale},
	{name = "PROP_HUMAN_SEAT_CHAIR"},
	{name = "PROP_HUMAN_SEAT_CHAIR_BANJO", isCompatible = IsPedHumanMale},
	{name = "PROP_HUMAN_SEAT_CHAIR_CLEAN_RIFLE"},
	{name = "PROP_HUMAN_SEAT_CHAIR_CLEAN_SADDLE"},
	{name = "PROP_HUMAN_SEAT_CHAIR_CRAB_TRAP", isCompatible = IsPedHumanMale},
	{name = "PROP_HUMAN_SEAT_CHAIR_CIGAR", isCompatible = IsPedHumanMale},
	{name = "PROP_HUMAN_SEAT_CHAIR_GROOMING_GROSS", isCompatible = IsPedHumanMale},
	{name = "PROP_HUMAN_SEAT_CHAIR_GROOMING_POSH", isCompatible = IsPedHumanFemale},
	{name = "PROP_HUMAN_SEAT_CHAIR_GUITAR", isCompatible = IsPedHumanMale},
	{name = "PROP_HUMAN_SEAT_CHAIR_KNIFE_BADASS", isCompatible = IsPedHumanMale},
	{name = "PROP_HUMAN_SEAT_CHAIR_KNITTING", isCompatible = IsPedHumanFemale},
	{name = "PROP_HUMAN_SEAT_CHAIR_PORCH"},
	{name = "PROP_HUMAN_SEAT_CHAIR_READING", isCompatible = IsPedHumanFemale},
	{name = "PROP_HUMAN_SEAT_CHAIR_TABLE_DRINKING"}
}

BedScenarios = {
	{name = "PROP_HUMAN_SLEEP_BED_PILLOW"},
	{name = "PROP_HUMAN_SLEEP_BED_PILLOW_HIGH", isCompatible = IsPedHumanMale},
	{name = "WORLD_HUMAN_SLEEP_GROUND_ARM"},
	{name = "WORLD_HUMAN_SLEEP_GROUND_PILLOW"},
	{name = "WORLD_HUMAN_SIT_FALL_ASLEEP"},
	{name = "WORLD_PLAYER_SLEEP_BEDROLL"},
	{name = "WORLD_PLAYER_SLEEP_GROUND"}
}

BathingAnimations = {
	{label = "Bath", dict = "mini_games@bathing@regular@arthur", name = "bathing_idle_02"},
	{label = "Bath: Scrub left arm", dict = "mini_games@bathing@regular@arthur", name = "left_arm_scrub_medium"},
	{label = "Bath: Scrub right arm", dict = "mini_games@bathing@regular@arthur", name = "right_arm_scrub_medium"},
	{label = "Bath: Scrub left leg", dict = "mini_games@bathing@regular@arthur", name = "left_leg_scrub_medium"},
	{label = "Bath: Scrub right leg", dict = "mini_games@bathing@regular@arthur", name = "right_leg_scrub_medium"}
}

EatingAnimationsMale = {
	{
		label = "Eat Dinner", 
		dicts = {
			{
				name ="amb_rest_sit@prop_human_seat_chair_table@eating@fork_knife@cutting@male_a@base",
				frames = {
					{
						name = "cutting_trans_chewing_01",
						time = 6000,
						flag = 1
					},
					{
						name = "cutting_trans_chewing_02",
						time = 2000,
						flag = 1
					},
					{
						name = "cutting_trans_chewing_03",
						time = 2000,
						flag = 1
					},
					{
						name = "cutting_trans_chewing_04",
						time = 2000,
						flag = 1
					}
				}
			}
		},
		props = {
			{
                model = 'p_dinnerknife01x',
                bone = 'IK_R_Hand',
                position = vector3(0.09, 0.04, -0.02),
                rotation = vector3(6.00, 0.09, -65.09),
                attach = true
            },
            {
                model = 'p_dinnerfork01x',
                bone = 'IK_L_Hand',
                position = vector3(0.09, 0.03, 0.02),
                rotation = vector3(02.00, 00.9, -65.09),
                attach = true
            }
		}
	},
	-- Spoons
	{
		label = "Eat Breakfast", 
		dicts = {
			{
				name = "amb_camp@prop_camp_seat_chair_table_stew@eating@male_a@idle_a",
				frames = {
					{
						name = "idle_a",
						time = 6000,
						flag = 1
					},
					{
						name = "idle_b",
						time = 3000,
						flag = 0
					},
					{
						name = "idle_c",
						time = 3000,
						flag = 0
					},
				},
			},
			{
				name = "amb_camp@prop_camp_seat_chair_table_stew@eating@male_a@idle_b",
				frames = {
					{
						name = "idle_d",
						time = 6000,
						flag = 1
					},
					{
						name = "idle_e",
						time = 3000,
						flag = 0
					},
					{
						name = "idle_f",
						time = 3000,
						flag = 0
					},
				},
			},
			{
				name = "amb_camp@prop_camp_seat_chair_table_stew@eating@male_a@idle_c",
				frames = {
					{
						name = "idle_g",
						time = 6000,
						flag = 1
					},
					{
						name = "idle_h",
						time = 3000,
						flag = 0
					},
					{
						name = "idle_i",
						time = 3000,
						flag = 0
					},
					{
						name = "idle_i",
						time = 3000,
						flag = 0
					},
				},
			},
		},
		props = {
			{
                model = 'p_spoon02x',
                bone = 'IK_R_Hand',
                position = vector3(0.09, 0.04, -0.02),
                rotation = vector3(6.00, 0.09, -65.09),
                attach = true
            }
		}
	}
}


EatingAnimationsFemale = {
	{
		label = "Eat Dinner", 
		dicts = {
			{
				name ="amb_rest_sit@prop_human_seat_chair_table@eating@fork_knife@cutting@female_a@base",
				frames = {
					{
						name = "cutting_trans_chewing_01",
						time = 10000,
						flag = 1
					},
					{
						name = "cutting_trans_chewing_02",
						time = 6000,
						flag = 1
					},
					{
						name = "cutting_trans_chewing_04",
						time = 6000,
						flag = 1
					},
					{
						name = "cutting_trans_chewing_05",
						time = 6000,
						flag = 1
					}
				}
			}
		},
		props = {
			{
                model = 'p_dinnerknife01x',
                bone = 'IK_R_Hand',
                position = vector3(0.09, 0.04, -0.02),
                rotation = vector3(6.00, 0.09, -65.09),
                attach = true
            },
            {
                model = 'p_dinnerfork01x',
                bone = 'IK_L_Hand',
                position = vector3(0.09, 0.03, 0.02),
                rotation = vector3(02.00, 00.9, -65.09),
                attach = true
            }
		}
	},
	-- Spoons
	{
		label = "Eat Breakfast", 
		dicts = {
			{
				name = "amb_camp@prop_camp_seat_chair_table_stew@eating@female_a@idle_b",
				frames = {
					{
						name = "idle_d",
						time = 6000,
						flag = 1
					},
					{
						name = "idle_f",
						time = 3000,
						flag = 0
					}
				}
			}
		},
		props = {
			{
                model = 'p_spoon02x',
                bone = 'IK_R_Hand',
                position = vector3(0.09, 0.04, -0.02),
                rotation = vector3(6.00, 0.09, -65.09),
                attach = true
            }
		}
	}
}