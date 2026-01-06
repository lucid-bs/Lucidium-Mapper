class_name AudioStreamWaveform
extends Panel

@export var audio_file : AudioStream

func generate_waveform(target_audio_file := audio_file):
	# This did NOT WORK
	
	var audio_playback := target_audio_file.instantiate_playback()
	var vol_data : PackedVector2Array
	if target_audio_file is AudioStreamWAV:
		vol_data = audio_playback.mix_audio(1, target_audio_file.mix_rate * audio_file.get_length())
		print(target_audio_file.mix_rate, " ", audio_file.get_length(), " ", target_audio_file.mix_rate * audio_file.get_length())
	elif target_audio_file is AudioStreamOggVorbis:
		vol_data = audio_playback.mix_audio(1, int(target_audio_file.packet_sequence.sampling_rate * audio_file.get_length()))
		print(target_audio_file.packet_sequence.sampling_rate, " ", audio_file.get_length(), " ", target_audio_file.packet_sequence.sampling_rate * audio_file.get_length())
	
	var itr : int = 0
	
	for i in vol_data:
		# Do stuff.
		print(i)
		# End Do Stuff
		itr += 1
	
	# Find a new approach, mix_audio always returns 118 with the above.
