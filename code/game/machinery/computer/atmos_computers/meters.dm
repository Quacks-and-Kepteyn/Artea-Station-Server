/obj/machinery/meter/monitored
	/// The unique string that represents which atmos chamber to associate with.
	var/chamber_id

	var/frequency = FREQ_ATMOS_STORAGE
	var/datum/radio_frequency/radio_connection

/obj/machinery/meter/monitored/Initialize(mapload)
	id_tag = chamber_id + "_sensor"
	radio_connection = SSradio.add_object(src, frequency, RADIO_ATMOSIA)
	return ..()

/obj/machinery/meter/monitored/Destroy()
	SSradio.remove_object(src, frequency)
	return ..()

/obj/machinery/meter/monitored/on_deconstruction()
	. = ..()
	SSair.broadcast_destruction(id_tag, frequency)

/obj/machinery/meter/monitored/process_atmos()
	. = ..()
	if(!radio_connection)
		return

	var/datum/signal/signal = new(list(
		"tag" = id_tag,
		"device" = "AM",
		"sigtype" = "status",
		"timestamp" = world.time,
		"gasmix" = gas_mixture_parser(target.return_air()),
	))
	radio_connection.post_signal(src, signal)

/obj/machinery/meter/monitored/layer2
	target_layer = 2

/obj/machinery/meter/monitored/layer4
	target_layer = 4

/obj/machinery/meter/monitored/waste_loop
	name = "waste loop gas flow meter"
	chamber_id = ATMOS_GAS_MONITOR_WASTE

/obj/machinery/meter/monitored/distro_loop
	name = "distribution loop gas flow meter"
	chamber_id = ATMOS_GAS_MONITOR_DISTRO
