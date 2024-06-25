# Aktivieren der .NET Framework Features
Enable-WindowsOptionalFeature -Online -FeatureName NetFx3 -All
Enable-WindowsOptionalFeature -Online -FeatureName NetFx4 -All

# Aktivieren der NFS Features
Enable-WindowsOptionalFeature -Online -FeatureName ServicesForNFS-ClientOnly -All
Enable-WindowsOptionalFeature -Online -FeatureName ClientForNFS-Infrastructure -All
Enable-WindowsOptionalFeature -Online -FeatureName NFS-Administration -All

# Aktivieren der Legacy Features
Enable-WindowsOptionalFeature -Online -FeatureName DirectPlay -All
Enable-WindowsOptionalFeature -Online -FeatureName LegacyComponents -All

# Aktivieren des Windows Media Players
Enable-WindowsOptionalFeature -Online -FeatureName WindowsMediaPlayer -All
Enable-WindowsOptionalFeature -Online -FeatureName MediaPlayback -All