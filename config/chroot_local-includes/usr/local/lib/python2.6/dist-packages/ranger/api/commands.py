# Copyright (C) 2009, 2010, 2011  Roman Zimbelmann <romanz@lavabit.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

import os
import ranger
import re
from collections import deque
from ranger.api import *
from ranger.core.shared import FileManagerAware
from ranger.ext.lazy_property import lazy_property

SETTINGS_RE = re.compile(r'^([^\s]+?)=(.*)$')
DELETE_WARNING = 'delete seriously? '

def alias(*_): pass # COMPAT

class CommandContainer(object):
	def __init__(self):
		self.commands = {}

	def __getitem__(self, key):
		return self.commands[key]

	def alias(self, new, old):
		try:
			self.commands[new] = self.commands[old]
		except:
			pass

	def load_commands_from_module(self, module):
		for var in vars(module).values():
			try:
				if issubclass(var, Command) and var != Command \
						and var != FunctionCommand:
					self.commands[var.get_name()] = var
			except TypeError:
				pass

	def load_commands_from_object(self, obj, filtr):
		for attribute_name in dir(obj):
			if attribute_name[0] == '_' or attribute_name not in filtr:
				continue
			attribute = getattr(obj, attribute_name)
			if hasattr(attribute, '__call__'):
				cmd = type(attribute_name, (FunctionCommand, ), dict())
				cmd._based_function = attribute
				cmd._function_name = attribute.__name__
				cmd._object_name = obj.__class__.__name__
				self.commands[attribute_name] = cmd

	def get_command(self, name, abbrev=True):
		if abbrev:
			lst = [cls for cmd, cls in self.commands.items() \
					if cls.allow_abbrev and cmd.startswith(name) \
					or cmd == name]
			if len(lst) == 0:
				raise KeyError
			if len(lst) == 1:
				return lst[0]
			if self.commands[name] in lst:
				return self.commands[name]
			raise ValueError("Ambiguous command")
		else:
			try:
				return self.commands[name]
			except KeyError:
				return None

	def command_generator(self, start):
		return (cmd + ' ' for cmd in self.commands if cmd.startswith(start))


class Command(FileManagerAware):
	"""Abstract command class"""
	name = None
	allow_abbrev = True
	resolve_macros = True
	escape_macros_for_shell = False
	quantifier = None
	_shifted = 0
	_setting_line = None

	def __init__(self, line, quantifier=None):
		self.line = line
		self.args = line.split()
		self.quantifier = quantifier
		try:
			self.firstpart = line[:line.rindex(' ') + 1]
		except ValueError:
			self.firstpart = ''

	@classmethod
	def get_name(self):
		classdict = self.__mro__[0].__dict__
		if 'name' in classdict and classdict['name']:
			return self.name
		else:
			return self.__name__

	def execute(self):
		"""Override this"""

	def tab(self):
		"""Override this"""

	def quick(self):
		"""Override this"""

	def cancel(self):
		"""Override this"""

	# Easy ways to get information
	def arg(self, n):
		"""Returns the nth space separated word"""
		try:
			return self.args[n]
		except IndexError:
			return ""

	def rest(self, n):
		"""Returns everything from and after arg(n)"""
		got_space = False
		word_count = 0
		for i in range(len(self.line)):
			if self.line[i] == " ":
				if not got_space:
					got_space = True
					word_count += 1
			elif got_space:
				got_space = False
				if word_count == n + self._shifted:
					return self.line[i:]
		return ""

	def start(self, n):
		"""Returns everything until (inclusively) arg(n)"""
		return ' '.join(self.args[:n]) + " " # XXX

	def shift(self):
		del self.args[0]
		self._shifted += 1

	def tabinsert(self, word):
		return ''.join([self._tabinsert_left, word, self._tabinsert_right])

	def parse_setting_line(self):
		if self._setting_line is not None:
			return self._setting_line
		match = SETTINGS_RE.match(self.rest(1))
		if match:
			self.firstpart += match.group(1) + '='
			result = [match.group(1), match.group(2), True]
		else:
			result = [self.arg(1), self.rest(2), ' ' in self.rest(1)]
		self._setting_line = result
		return result

	# XXX: Lazy properties? Not so smart? self.line can change after all!
	@lazy_property
	def _tabinsert_left(self):
		try:
			return self.line[:self.line[0:self.pos].rindex(' ') + 1]
		except ValueError:
			return ''

	@lazy_property
	def _tabinsert_right(self):
		return self.line[self.pos:]

	# COMPAT: this is still used in old commands.py configs
	def _tab_only_directories(self):
		from os.path import dirname, basename, expanduser, join

		cwd = self.fm.env.cwd.path

		rel_dest = self.rest(1)

		# expand the tilde into the user directory
		if rel_dest.startswith('~'):
			rel_dest = expanduser(rel_dest)

		# define some shortcuts
		abs_dest = join(cwd, rel_dest)
		abs_dirname = dirname(abs_dest)
		rel_basename = basename(rel_dest)
		rel_dirname = dirname(rel_dest)

		try:
			# are we at the end of a directory?
			if rel_dest.endswith('/') or rel_dest == '':
				_, dirnames, _ = next(os.walk(abs_dest))

			# are we in the middle of the filename?
			else:
				_, dirnames, _ = next(os.walk(abs_dirname))
				dirnames = [dn for dn in dirnames \
						if dn.startswith(rel_basename)]
		except (OSError, StopIteration):
			# os.walk found nothing
			pass
		else:
			dirnames.sort()

			# no results, return None
			if len(dirnames) == 0:
				return

			# one result. since it must be a directory, append a slash.
			if len(dirnames) == 1:
				return self.start(1) + join(rel_dirname, dirnames[0]) + '/'

			# more than one result. append no slash, so the user can
			# manually type in the slash to advance into that directory
			return (self.start(1) + join(rel_dirname, dirname)
					for dirname in dirnames)

	def _tab_directory_content(self):
		from os.path import dirname, basename, expanduser, join

		cwd = self.fm.env.cwd.path

		rel_dest = self.rest(1)

		# expand the tilde into the user directory
		if rel_dest.startswith('~'):
			rel_dest = expanduser(rel_dest)

		# define some shortcuts
		abs_dest = join(cwd, rel_dest)
		abs_dirname = dirname(abs_dest)
		rel_basename = basename(rel_dest)
		rel_dirname = dirname(rel_dest)

		try:
			# are we at the end of a directory?
			if rel_dest.endswith('/') or rel_dest == '':
				_, dirnames, filenames = next(os.walk(abs_dest))
				names = dirnames + filenames

			# are we in the middle of the filename?
			else:
				_, dirnames, filenames = next(os.walk(abs_dirname))
				names = [name for name in (dirnames + filenames) \
						if name.startswith(rel_basename)]
		except (OSError, StopIteration):
			# os.walk found nothing
			pass
		else:
			names.sort()

			# no results, return None
			if len(names) == 0:
				return

			# one result. since it must be a directory, append a slash.
			if len(names) == 1:
				return self.start(1) + join(rel_dirname, names[0]) + '/'

			# more than one result. append no slash, so the user can
			# manually type in the slash to advance into that directory
			return (self.start(1) + join(rel_dirname, name) for name in names)


class FunctionCommand(Command):
	_based_function = None
	_object_name = ""
	_function_name = "unknown"
	def execute(self):
		if not self._based_function:
			return
		if len(self.args) == 1:
			try:
				return self._based_function(**{'narg':self.quantifier})
			except TypeError:
				return self._based_function()

		args, keywords = list(), dict()
		for arg in self.args[1:]:
			equal_sign = arg.find("=")
			value = arg if (equal_sign is -1) else arg[equal_sign + 1:]
			try:
				value = int(value)
			except:
				if value in ('True', 'False'):
					value = (value == 'True')
				else:
					try:
						value = float(value)
					except:
						pass

			if equal_sign == -1:
				args.append(value)
			else:
				keywords[arg[:equal_sign]] = value

		if self.quantifier is not None:
			keywords['narg'] = self.quantifier

		try:
			if self.quantifier is None:
				return self._based_function(*args, **keywords)
			else:
				try:
					return self._based_function(*args, **keywords)
				except TypeError:
					del keywords['narg']
					return self._based_function(*args, **keywords)
		except TypeError:
			if ranger.arg.debug:
				raise
			else:
				self.fm.notify("Bad arguments for %s.%s: %s, %s" %
						(self._object_name, self._function_name,
							repr(args), repr(keywords)), bad=True)
