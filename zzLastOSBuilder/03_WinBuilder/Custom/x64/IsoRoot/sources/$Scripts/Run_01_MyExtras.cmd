@echo off
wmic path Win32_UserAccount set PasswordExpires=False
wmic UserAccount set PasswordExpires=False